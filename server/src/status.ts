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
        id: 'Route 1', polylinePoints: [], busStops: []
    }, {
        id: 'Route 2', polylinePoints: [], busStops: []
    }
];