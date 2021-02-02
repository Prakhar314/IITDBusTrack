import express, { Application, Request, Response, NextFunction } from 'express';
import admin from './admin';
import { BusStatus } from './interfaces';
import { AdminAuthMiddleware, UserAuthMiddleware } from './middlewares'
import { addBusStatus, getRoute, getRouteIndex, removeBusStatus, routeDetailsList, updateBusStatus } from './status'

const app: Application = express();

app.use(express.json());// for parsing application/json
app.use(express.urlencoded({ extended: true }));
app.set("port", process.env.PORT || 3000);

let http = require("http").Server(app);
let io = require("socket.io")(http);


admin
    .auth()
    .setCustomUserClaims('SwkV5TXNZhRpmPnRmtSpAwfGJmw1', { admin: true })
    .then(() => {
        // The new custom claims will propagate to the user's ID token the
        // next time a new one is issued.
    });

app.get('/', (req: Request, res: Response, next: NextFunction) => {
    res.send('Hello World');
});

app.use('/getRoutes', UserAuthMiddleware);
app.get('/getRoutes', (req: Request, res: Response, next: NextFunction) =>{
    res.send(routeDetailsList);
});

app.use('/setDriver', AdminAuthMiddleware);
app.post('/setDriver', (req: Request, res: Response, next: NextFunction) => {

    admin
        .auth()
        .setCustomUserClaims(req.body.uid, { driver: true })
        .then(() => {
            res.json({ 'message': 'Done!' });
        }).catch((error) => res.status(500).send(error));

});


io.use((socket: any, next: any) => {
    if (socket.handshake.auth && socket.handshake.auth.token) {
        const token = socket.handshake.auth.token;
        admin.auth().verifyIdToken(token).then((claims) => {
            socket.decoded = claims;
        })
            .catch((error) => {
                next(error);
            });
    }
    else {
        next(new Error("Unauthorized"));
    }
});

io.on("connection", function (socket: any) {
    console.log("connected");
    if (socket.decoded && socket.decoded.driver) {
        const routeID = socket.query.routeID;
        const initialStatus: BusStatus = socket.query.busStatus;
        addBusStatus(routeID, initialStatus);
        socket.on('update', (room: string, locStatus: BusStatus) => {
            if(locStatus.newStopPassed){
                // TODO: Firebase Notif
                if(locStatus.stopsVisited>0){
                    io.emit('stopPassed',routeDetailsList[getRouteIndex(room)].busStops[locStatus.stopsVisited-1]);
                }
            }
            io.to(room).volatile.emit('location', updateBusStatus(room, locStatus));
        });
        socket.on('disconnect', (reason: string) => {
            removeBusStatus(routeID, initialStatus.busid);
        })
    }
    else {
        socket.on('join', (room: string) => {
            socket.join(room);
            socket.volatile.emit('location', getRoute(room));
        })
    }
});

const server = http.listen(3000, function () {
    console.log("listening on *:3000");
});