import 'package:app/modules/data/interfaces.dart';
import 'package:app/modules/home/mapWidget.dart';
import 'package:app/modules/login/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/dataProvider.dart';

class UserHome extends StatefulWidget {
  final DataProvider dataProvider;

  const UserHome(this.dataProvider, {Key key}) : super(key: key);
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  Function disconnectSocket;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: widget.dataProvider,
        child: Consumer<DataProvider>(builder: (ctx, dp, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text('User'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () =>
                        context.read<AuthenticationService>().signOut(),
                  )
                ],
              ),
              body: dp.routesLoaded
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                              value: dp
                                  .routeDetailsList[dp.currentRouteIndex ?? 0]
                                  .id,
                              hint: Text('Select a route'),
                              items: dp.routeDetailsList
                                  .map((value) => DropdownMenuItem<String>(
                                        value: value.id,
                                        child: new Text(value.id),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                dp.subscribe(value);
                                disconnectSocket = dp.socket.disconnect;
                                dp.setCurrentRoute(value);
                              }),
                          MapWidget()
                        ],
                      ),
                    )
                  : CircularProgressIndicator());
        }));
  }

  @override
  void dispose() {
    disconnectSocket();
    super.dispose();
  }
}
