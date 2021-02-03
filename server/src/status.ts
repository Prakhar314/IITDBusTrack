import { BusStatus, Status, Route, RouteDetails } from './interfaces';

export const currentStatus: Status = {
    routes: [{ id: 'Route 1' }, { id: 'Route 2' }]
};

export const updateBusStatus = (routeID: string, busStatus: BusStatus): Route => {
    const routeToPushTo = getRoute(routeID);
    if (routeToPushTo.locationData) {
        const index = routeToPushTo.locationData.findIndex((value: BusStatus) => value.busid == busStatus.busid);
        if (index !== -1) {
            routeToPushTo.locationData[index] = busStatus;
        }
        else {
            routeToPushTo.locationData.push(busStatus);
        }
    }
    else {
        routeToPushTo.locationData = [busStatus];
    }
    return routeToPushTo;
}

export const removeBusStatus = (routeID: string, busID: string): Route => {
    const routeToDeleteFrom = getRoute(routeID);
    if (routeToDeleteFrom.locationData) {
        const index = routeToDeleteFrom.locationData.findIndex((value: BusStatus) => value.busid == busID);
        if (index !== -1) {
            routeToDeleteFrom.locationData.splice(index, 1);
        }
    }
    return routeToDeleteFrom;
}

export const getRoute = (routeID: string): Route => {
    const routeIndex = currentStatus.routes.findIndex((value: Route) => value.id == routeID);
    return currentStatus.routes[routeIndex];
}

export const getRouteIndex = (routeID: string): number => {
    return currentStatus.routes.findIndex((value: Route) => value.id == routeID);
}

export const routeDetailsList: (RouteDetails)[] = [
    {
        id: 'Route 1', polylinePoints: [{ "lat": 28.544827, "long": 77.194233 },
        { "lat": 28.544083, "long": 77.192055 },
        { "lat": 28.544019, "long": 77.191716 },
        { "lat": 28.546049, "long": 77.186793 },
        { "lat": 28.545369, "long": 77.186321 },
        { "lat": 28.545093, "long": 77.186006 },
        { "lat": 28.544668, "long": 77.18574 },
        { "lat": 28.544328, "long": 77.185401 },
        { "lat": 28.544285, "long": 77.185002 },
        { "lat": 28.545273, "long": 77.182595 },
        { "lat": 28.545273, "long": 77.182522 },
        { "lat": 28.547335, "long": 77.183587 },
        { "lat": 28.548897, "long": 77.184434 },
        { "lat": 28.549107, "long": 77.18446 },
        { "lat": 28.549127, "long": 77.184552 },
        { "lat": 28.549044, "long": 77.184601 },
        { "lat": 28.548586, "long": 77.185652 },
        { "lat": 28.548398, "long": 77.185695 },
        { "lat": 28.546854, "long": 77.185153 },
        { "lat": 28.546829, "long": 77.185034 },
        { "lat": 28.54667, "long": 77.185 },
        { "lat": 28.546596, "long": 77.185083 },
        { "lat": 28.546657, "long": 77.185244 },
        { "lat": 28.546087, "long": 77.186718 },
        { "lat": 28.544031, "long": 77.191602 },
        { "lat": 28.544859, "long": 77.194138 },
        { "lat": 28.544963, "long": 77.194516 },
        { "lat": 28.544755, "long": 77.194572 },
        { "lat": 28.544687, "long": 77.194376 },
        { "lat": 28.544822, "long": 77.194222 }
        ], busStops: [
            { "name": "IRD", "coord": { "lat": 28.544418, "long": 77.192779 } },
            { "name": "Nalanda", "coord": { "lat": 28.546444, "long": 77.183128 } },
            { "name": "Jwala", "coord": { "lat": 28.548872, "long": 77.184972 } },
            { "name": "Shivalik", "coord": { "lat": 28.547733, "long": 77.185517 } },
            { "name": "Hospital", "coord": { "lat": 28.545479, "long": 77.188184 } },
        ]
    }, {
        id: 'Route 2', polylinePoints: [{ "lat": 28.544926, "long": 77.194427 },
        { "lat": 28.544137, "long": 77.192102 },
        { "lat": 28.544029, "long": 77.191802 },
        { "lat": 28.544061, "long": 77.191421 },
        { "lat": 28.54446, "long": 77.190436 },
        { "lat": 28.546023, "long": 77.186812 },
        { "lat": 28.545405, "long": 77.186362 },
        { "lat": 28.545182, "long": 77.186076 },
        { "lat": 28.544942, "long": 77.185908 },
        { "lat": 28.544643, "long": 77.185745 },
        { "lat": 28.544528, "long": 77.185863 },
        { "lat": 28.543618, "long": 77.188033 },
        { "lat": 28.541975, "long": 77.192329 },
        { "lat": 28.540886, "long": 77.195095 },
        { "lat": 28.540012, "long": 77.197574 },
        { "lat": 28.540028, "long": 77.197647 },
        { "lat": 28.542928, "long": 77.199036 },
        { "lat": 28.544264, "long": 77.195562 },
        { "lat": 28.544647, "long": 77.194582 },
        { "lat": 28.544907, "long": 77.194591 },
        { "lat": 28.544922, "long": 77.194432 }], busStops: [
            { "name": "IDDC", "coord": { "lat": 28.544395, "long": 77.192812 } },
            { "name": "IITD Hospital", "coord": { "lat": 28.545432, "long": 77.188151 } },
            { "name": "Kailash Hostel", "coord": { "lat": 28.544090, "long": 77.195960 } },
        ]
    }
];