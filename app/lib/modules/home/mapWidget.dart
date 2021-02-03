import 'dart:math';

import 'package:app/modules/data/dataProvider.dart';
import 'package:app/modules/data/interfaces.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  MapController _mapController;
  var interActiveFlags = InteractiveFlag.all;
  var currentLatLng = LatLng(28.545202, 77.188378);
  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<DataProvider>().streamSocket.getResponse,
      builder: (context, AsyncSnapshot<BusRoute> snapshot) {
        if (snapshot.hasData) {
          // return Text(snapshot.data.toJson().toString());
          return Flexible(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                nePanBoundary: LatLng(28.5489, 77.2011),
                swPanBoundary: LatLng(28.5430, 77.1785),
                // bounds: LatLngBounds(
                //     LatLng(28.5505, 77.1818), LatLng(28.5376, 77.1964)),
                minZoom: 16,
                maxZoom: 18,
                center: LatLng(currentLatLng.latitude, currentLatLng.longitude),
                zoom: 17.0,
                interactiveFlags: interActiveFlags,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate:
                      'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                  subdomains: ['a', 'b', 'c', 'd'],
                  // For example purposes. It is recommended to use
                  // TileProvider with a caching and retry strategy, like
                  // NetworkTileProvider or CachedNetworkTileProvider
                  tileProvider: NonCachingNetworkTileProvider(),
                ),
                PolylineLayerOptions(polylines: [
                  Polyline(
                      color: Colors.grey.shade400,
                      strokeWidth: 4,
                      points: context
                          .read<DataProvider>()
                          .currentRoute
                          .polylinePoints
                          .map((e) => e.latlng)
                          .toList())
                ]),
                MarkerLayerOptions(
                    markers: context
                        .read<DataProvider>()
                        .currentRoute
                        .busStops
                        .map((e) => Marker(
                              point: e.coord.latlng,
                              builder: (context) => Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[400],
                                  ),
                                  child: Icon(
                                    Icons.directions_bus,
                                    color: Colors.grey[200],
                                  )),
                            ))
                        .toList()),
                if (snapshot.data.locationData != null)
                  MarkerLayerOptions(
                      markers: snapshot.data.locationData
                          .where((element) => element.coord != null)
                          .map((e) => Marker(
                                width: 80.0,
                                height: 80.0,
                                point: e.coord.latlng,
                                builder: (ctx) => Transform.rotate(
                                    angle: e.bearing * pi / 180,
                                    child: PulsatingMarker()),
                              ))
                          .toList())
              ],
            ),
          );
        } else {
          return Text('No Data');
        }
      },
    );
  }
}

class PulsatingMarker extends StatefulWidget {
  const PulsatingMarker({
    Key key,
  }) : super(key: key);

  @override
  _PulsatingMarkerState createState() => _PulsatingMarkerState();
}

class _PulsatingMarkerState extends State<PulsatingMarker>
    with TickerProviderStateMixin {
  double endV = 1;
  AnimationController _pulseControl;
  Animation<double> _pulseTween, _fadeTween;
  bool moving = true;
  @override
  void initState() {
    _pulseControl =
        AnimationController(duration: Duration(seconds: 1), vsync: this)
          ..forward();
    _pulseTween = Tween<double>(begin: 0, end: 1).animate(_pulseControl);
    _fadeTween = Tween<double>(begin: 1, end: 0).animate(_pulseControl);
    // ..repeat();
    _pulseControl.addStatusListener(onPulseComplete);
    super.initState();
  }

  void onPulseComplete(status) {
    // print(status);
    if (status == AnimationStatus.completed && moving) {
      _pulseControl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulseControl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Stack(children: [
        ScaleTransition(
          scale: _pulseTween,
          child: FadeTransition(
            opacity: _fadeTween,
            child: Center(
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            height: 30,
            child: Icon(
              Icons.arrow_upward,
              color: Colors.white,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey,
            ),
          ),
        ),
      ]),
    );
  }
}

class LatLngTween extends Tween<LatLng> {
  /// Creates a [LatLng] tween.
  ///
  /// The [begin] and [end] properties may be null; the null value
  /// is treated as an empty LatLng.
  LatLngTween({LatLng begin, LatLng end}) : super(begin: begin, end: end);

  /// Returns the value this variable has at the given animation clock value.
  @override
  LatLng lerp(double t) {
    assert(t != null);
    if (begin == null && end == null) return null;
    double lat, lng;
    if (begin == null) {
      lat = end.latitude * t;
      lng = end.longitude * t;
    } else if (end == null) {
      lat = begin.latitude * (1.0 - t);
      lng = begin.longitude * (1.0 - t);
    } else {
      lat = lerpDouble(begin.latitude, end.latitude, t);
      lng = lerpDouble(begin.longitude, end.longitude, t);
    }
    return LatLng(lat, lng);
  }

  @protected
  double lerpDouble(double a, double b, double t) {
    if (a == null && b == null) return null;
    a ??= 0.0;
    b ??= 0.0;
    return a + (b - a) * t;
  }
}
