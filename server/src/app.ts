import express, { Application, Request, Response, NextFunction } from 'express';
import admin from './admin';
import {LocationData} from './status';

const app: Application = express();

let http = require("http").Server(app);
let io = require("socket.io")(http);

app.get('/', (req: Request, res: Response, next: NextFunction) => {
    res.send('Hello World');
});


app.set("port", process.env.PORT || 3000);

io.use((socket: any, next: any) => {
    const token = socket.handshake.auth.token;
    admin.auth().verifyIdToken(token).then((claims) => {
        if (claims.admin === true) {
            next();
        }
        else {
            throw new Error("Unauthorized");
        }
    })
        .catch((error) => {
            console.log(error);
        });
});

io.on("connection", function (socket: any) {
    console.log("connected");
});

const server = http.listen(3000, function () {
    console.log("listening on *:3000");
});