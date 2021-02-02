export interface Status {
    routes: (Route)[];
}
export interface Route {
    id: string;
    locationData?: (BusStatus)[] | null;
}

export interface RouteDetails {
    id: string;
    polylinePoints: (Coord)[];
    busStops: (BusStop)[];
}

export interface BusStatus {
    status: string;
    speed: number;
    stopsVisited: number;
    newStopPassed: boolean;
    coord: Coord;
    busid: string;
    bearing: number;
    time: number;
}

export interface Coord {
    lat: number;
    long: number;
}

export interface BusStop {
    name: string;
    coord: Coord;
}
