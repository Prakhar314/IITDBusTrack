import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:app/modules/data/interfaces.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../../constants.dart';

class DataProvider extends ChangeNotifier {
  final String _authToken;
  List<RouteDetails> routeDetailsList;
  IO.Socket socket;
  bool routesLoaded = false;
  bool socketConnected = false;

  StreamSocket streamSocket = StreamSocket();

  DataProvider(this._authToken) {
    getRoutes();
  }

  Future<void> getRoutes() async {
    routesLoaded = false;
    var response = await http.get(
      url + '/getRoutes',
      headers: {
        'Authorization': 'Bearer $_authToken',
      },
    );
    print(response);
    List<dynamic> responseList = json.decode(response.body);
    routeDetailsList =
        responseList.map((e) => RouteDetails.fromJson(e)).toList();
    routesLoaded = true;
    notifyListeners();
  }

  void subscribe(String routeId) {
    getSocket();
    socket.emit('join', routeId);
    socket.on('location', (data) {
      print(data);
      streamSocket.addResponse(BusRoute.fromJson(json.decode(data)));
    });
  }

  IO.Socket getSocket([Map<String, dynamic> query]) {
    IO.OptionBuilder opn = IO.OptionBuilder()
        .setTransports(['websocket']).setExtraHeaders({'auth': _authToken});
    if (query != null) {
      print(query);
      opn = opn.setQuery(query);
    }
    socket = IO.io(url, opn.build());
    print('conect stat');
    socket.onConnect((data) {
      socketConnected = true;
      notifyListeners();
      print('socket connected');
    });
    socket.onConnectError((data) => print('socket connection error $data'));
    socket.onDisconnect((data) {
      socketConnected = false;
      notifyListeners();
      print('socket disconnected');
    });
    return socket;
  }

  Function getServerUpdateFunction(String routeID, String busID) {
    // void func() {
    //   print('aaaaaaaaa');
    // }

    // Map<Str
    getSocket({'routeID': routeID, 'busID': busID});
    // TODO:change init

    BusState currentBusState = new BusState(routeDetailsList
        .firstWhere((element) => element.id == routeID)
        .busStops);

    void func(BusStatus newStatus) {
      print('kkk');
      if (socket.connected) {
        print('emitting new location');
        socket.emit(
            'update', currentBusState.getUpdatedStatus(newStatus).toJson());
      }
    }

    return func;
  }
}

class BusState {
  List<BusStop> busStopList;
  BusStatus cacheStatus;
  BusState(this.busStopList);

  BusStatus getUpdatedStatus(BusStatus newStatus) {
    newStatus.newStopPassed = false;
    if (cacheStatus == null || cacheStatus.stopsVisited == busStopList.length) {
      newStatus.stopsVisited = 0;
    } else {
      newStatus.stopsVisited = cacheStatus.stopsVisited;
      for (int i = cacheStatus.stopsVisited; i < busStopList.length; i++) {
        if (distance(busStopList[i].coord, newStatus.coord) < 100) {
          newStatus.stopsVisited = i + 1;
          newStatus.newStopPassed = true;
          break;
        }
      }
    }
    cacheStatus = newStatus;
    return newStatus;
  }

  double distance(Coordinates stopCoord, Coordinates busCoord) {
    double lat1 = stopCoord.lat;
    double lat2 = busCoord.lat;
    double lon1 = stopCoord.long;
    double lon2 = busCoord.long;
    double p = pi / 180;
    double a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }
}

class StreamSocket {
  final _socketResponse = StreamController<BusRoute>();

  void Function(BusRoute) get addResponse => _socketResponse.sink.add;

  Stream<BusRoute> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
