export interface Status {
    routes?: (Route)[] | null;
}
export interface Route {
    status: string;
    locationData:LocationData;
}

export interface LocationData{
    speed: number;
    coord: Coord;
    busid: number;
    bearing: number;
    time: number;
}

export interface Coord {
    lat: number;
    long: number;
}
