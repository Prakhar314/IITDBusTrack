import express, { Application, Request, Response, NextFunction } from 'express';
import admin from './admin';
import { BusStatus } from './interfaces';
import { AdminAuthMiddleware, errorMiddleware, UserAuthMiddleware } from './middlewares'
import { getRoute, getRouteIndex, removeBusStatus, routeDetailsList, updateBusStatus } from './status'
import cors from 'cors';

const app: Application = express();

app.use(express.json());// for parsing application/json
app.use(express.urlencoded({ extended: true }));
app.use(cors());
let http = require("http").Server(app);
let io = require("socket.io")(http, {
    cors: {
        origin: '*',
    }
});


admin
    .auth()
    .setCustomUserClaims('SwkV5TXNZhRpmPnRmtSpAwfGJmw1', { admin: true })
    .then(() => {
        // The new custom claims will propagate to the user's ID token the
        // next time a new one is issued.
    });

app.get('/', (req: Request, res: Response, next: NextFunction) => {
    res.sendFile(__dirname + '/index.html');
});

app.use('/getRoutes', UserAuthMiddleware);
app.get('/getRoutes', (req: Request, res: Response, next: NextFunction) => {
    res.send(routeDetailsList);
});

app.use('/setDriver', AdminAuthMiddleware);
app.post('/setDriver', (req: Request, res: Response, next: NextFunction) => {
    admin
        .auth().getUserByEmail(req.body.email).then((user) => {
            admin.auth().setCustomUserClaims(user.uid, { driver: true })
                .then(() => {
                    res.json({ 'message': 'Done!' });
                }).catch((error) => { res.status(500).send(error); })
        }).catch((error) => { res.status(500).send(error); });

});


io.use((socket: any, next: any) => {
    // console.log('got request');
    if (socket.handshake.headers.auth) {
        const token = socket.handshake.headers.auth;
        admin.auth().verifyIdToken(token).then((decodedIDToken) => {
            // console.log('verified');
            socket.decoded = decodedIDToken;
            next();
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
    console.log(socket.handshake.query);
    if (socket.decoded && socket.decoded.driver) {
        const routeID = socket.handshake.query.routeID;
        const busID: string = socket.handshake.query.busID;
        const route = routeDetailsList[getRouteIndex(routeID)];
        console.log('driver connected');
        socket.on('update', (locStatus: BusStatus) => {
            console.log('update received');
            // console.log(getRoute(routeID));
            if (locStatus.newStopPassed) {
                // TODO: Firebase Notif
                if (locStatus.stopsVisited > 0) {
                    io.emit('stopPassed', route.busStops[locStatus.stopsVisited - 1]);
                }
            }
            io.to(routeID).volatile.emit('location', updateBusStatus(routeID, locStatus));
        });
        socket.on('disconnect', (reason: string) => {
            console.log('bus disconnected');
            removeBusStatus(routeID, busID);
            io.to(routeID).volatile.emit('location', getRoute(routeID));
        })
    }
    else {
        let currentRoom='';
        socket.on('join', (room: string) => {
            console.log('user joined');
            if(currentRoom.length!==0){
                console.log('old room'+currentRoom);
                socket.leave(currentRoom);
            }
            currentRoom=room;
            socket.join(room);
            socket.volatile.emit('location', getRoute(room));
        })
    }
});

app.use(errorMiddleware);
const server = http.listen(3000, function () {
    console.log("listening on *:3000");
});