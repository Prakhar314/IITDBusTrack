import 'package:app/modules/data/dataProvider.dart';
import 'package:app/modules/data/interfaces.dart';
import 'package:app/modules/login/auth_service.dart';
import 'package:background_location/background_location.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class DriverHome extends StatefulWidget {
  final DataProvider dataProvider;

  const DriverHome(this.dataProvider, {Key key}) : super(key: key);

  @override
  _DriverHomeState createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  bool locationServiceRunning = false;
  Function destroySocket;

  @override
  Widget build(BuildContext context1) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Driver'),
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => context1.read<AuthenticationService>().signOut(),
            )
          ],
        ),
        body: ChangeNotifierProvider.value(
          value: widget.dataProvider,
          child: Consumer<DataProvider>(
            builder: (ctx, dp, child) {
              if (dp.routesLoaded) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!locationServiceRunning)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Select a route'),
                            Padding(padding: EdgeInsets.all(8)),
                            DropdownButton<String>(
                              value: dp
                                  .routeDetailsList[dp.currentRouteIndex ?? 0]
                                  .id,
                              items:
                                  dp.routeDetailsList.map((RouteDetails value) {
                                return DropdownMenuItem<String>(
                                  value: value.id,
                                  child: new Text(value.id),
                                );
                              }).toList(),
                              onChanged: (id) {
                                dp.setCurrentRoute(id);
                              },
                            ),
                          ],
                        ),
                      if (!locationServiceRunning)
                        RaisedButton(
                            child: Text('Start'),
                            onPressed: () async {
                              print('starting');
                              Function locListener = dp.getServerUpdateFunction(
                                  dp.currentRoute.id,
                                  context1
                                      .read<AuthenticationService>()
                                      .firebaseAuth
                                      .currentUser
                                      .uid);
                              await BackgroundLocation.setAndroidNotification(
                                title: "Bus tracking",
                                message: "Your location is being used",
                                icon: "@mipmap/ic_launcher",
                              );
                              await BackgroundLocation.setAndroidConfiguration(
                                  1000);
                              await BackgroundLocation.stopLocationService();
                              await BackgroundLocation.startLocationService();
                              print(locListener);
                              String busid = context1
                                  .read<AuthenticationService>()
                                  .firebaseAuth
                                  .currentUser
                                  .uid;
                              print(locListener(BusStatus()));
                              BackgroundLocation.getLocationUpdates((location) {
                                // locListener();
                                // Any error here won't print.
                                locListener(BusStatus(
                                    bearing: location.bearing.toInt(),
                                    busid: busid,
                                    coord: Coordinates(
                                        lat: location.latitude,
                                        long: location.longitude),
                                    speed: location.speed,
                                    status: location.speed == 0 ? 'S' : 'M',
                                    time: location.time.toInt()));
                              });
                              setState(() {
                                destroySocket = () => dp.socket.disconnect();
                                locationServiceRunning = true;
                              });
                            }),
                      if (locationServiceRunning)
                        RaisedButton(
                            child: Text('Stop'),
                            onPressed: () {
                              BackgroundLocation.stopLocationService();
                              destroySocket();
                              setState(() {
                                locationServiceRunning = false;
                              });
                            })
                    ],
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  // Future<bool> havePermissions() async {
  //   var havePermit = await BackgroundLocation.checkPermissions();
  //   return havePermit==PermissionStatus.granted;
  // }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    destroySocket();
    super.dispose();
  }
}
