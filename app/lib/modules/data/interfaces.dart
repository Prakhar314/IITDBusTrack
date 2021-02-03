class RouteDetails {
  String id;
  List<Coordinates> polylinePoints;
  List<BusStop> busStops;

  RouteDetails({this.id, this.polylinePoints, this.busStops});

  RouteDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['polylinePoints'] != null) {
      polylinePoints = new List<Coordinates>();
      json['polylinePoints'].forEach((v) {
        polylinePoints.add(new Coordinates.fromJson(v));
      });
    }
    if (json['busStops'] != null) {
      busStops = new List<BusStop>();
      json['busStops'].forEach((v) {
        busStops.add(new BusStop.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.polylinePoints != null) {
      data['polylinePoints'] =
          this.polylinePoints.map((v) => v.toJson()).toList();
    }
    if (this.busStops != null) {
      data['busStops'] = this.busStops.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Coordinates {
  double lat;
  double long;

  Coordinates({this.lat, this.long});

  Coordinates.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}

class BusStop {
  String name;
  Coordinates coord;

  BusStop({this.name, this.coord});

  BusStop.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    coord =
        json['coord'] != null ? new Coordinates.fromJson(json['coord']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.coord != null) {
      data['coord'] = this.coord.toJson();
    }
    return data;
  }
}

class BusRoute {
  String id;
  List<BusStatus> locationData;

  BusRoute({this.id, this.locationData});

  BusRoute.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['locationData'] != null) {
      locationData = new List<BusStatus>();
      json['locationData'].forEach((v) {
        locationData.add(new BusStatus.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.locationData != null) {
      data['locationData'] = this.locationData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BusStatus {
  String status;
  double speed;
  int stopsVisited;
  bool newStopPassed;
  Coordinates coord;
  String busid;
  double bearing;
  double time;

  BusStatus(
      {this.status,
      this.speed,
      this.stopsVisited,
      this.newStopPassed,
      this.coord,
      this.busid,
      this.bearing,
      this.time});

  BusStatus.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    speed = json['speed'];
    stopsVisited = json['stopsVisited'];
    newStopPassed = json['newStopPassed'];
    coord =
        json['coord'] != null ? new Coordinates.fromJson(json['coord']) : null;
    busid = json['busid'];
    bearing = json['bearing'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['speed'] = this.speed;
    data['stopsVisited'] = this.stopsVisited;
    data['newStopPassed'] = this.newStopPassed;
    if (this.coord != null) {
      data['coord'] = this.coord.toJson();
    }
    data['busid'] = this.busid;
    data['bearing'] = this.bearing;
    data['time'] = this.time;
    return data;
  }
}
