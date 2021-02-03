import 'package:app/modules/data/interfaces.dart';
import 'package:app/modules/login/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  final List<RouteDetails> busRoutes;

  const SettingsScreen(this.busRoutes, {Key key}) : super(key: key);
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const String storageKey = 'iitdbustrack';
  final LocalStorage storage = new LocalStorage(storageKey);
  bool initialized = false;
  List<String> subscribedTopics;

  void _addItem(String item) {
    if (!subscribedTopics.contains(item)) {
      setState(() {
        subscribedTopics.add(item);
      });
      _saveToStorage();
    }
  }

  void _removeItem(String item) {
    if (subscribedTopics.contains(item)) {
      setState(() {
        subscribedTopics.remove(item);
      });
      _saveToStorage();
    }
  }

  void _saveToStorage() {
    storage.setItem(storageKey, subscribedTopics);
  }

  @override
  Widget build(BuildContext context) {
    List<String> busStops = [];
    for (var busRoute in widget.busRoutes) {
      for (var busStop in busRoute.busStops) {
        if (!busStops.contains(busStop.name)) {
          busStops.add(busStop.name);
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: FutureBuilder(
        future: storage.ready,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!initialized) {
            var items = storage.getItem('iitdbustrack');

            if (items != null) {
              subscribedTopics = items;
            } else {
              subscribedTopics = [];
            }

            initialized = true;
          }

          return ListView.builder(
            itemCount: busStops.length,
            itemBuilder: (bc, i) => SwitchListTile(
              title: Text(busStops[i]),
              value: subscribedTopics.contains(busStops[i]),
              onChanged: (subscribe) {
                // if (subscribe) {
                //   context
                //       .read<AuthenticationService>()
                //       .subscribeToTopic(busStops[i])
                //       .then((value) => {
                //             if (value) {_addItem(busStops[i])}
                //           });
                // } else {
                //   context
                //       .read<AuthenticationService>()
                //       .unsubscribeFromTopic(busStops[i])
                //       .then((value) => {
                //             if (value) {_removeItem(busStops[i])}
                //           });
                // }
              },
            ),
          );
        },
      ),
    );
  }
}
