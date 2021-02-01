import express, { Application, Request, Response, NextFunction } from 'express';
import admin from './admin';
import { LocationData } from './status';

const app: Application = express();

app.use(express.json());// for parsing application/json
app.use(express.urlencoded({ extended: true }));

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

app.get('/setDriver', (req: Request, res: Response, next: NextFunction) => {

    if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
        let authToken = req.headers.authorization.split(' ')[1];
        if (req.body.uid) {
            admin.auth().verifyIdToken(authToken).then((claims) => {
                if (claims.admin === true) {

                    admin
                        .auth()
                        .setCustomUserClaims(req.body.uid, { driver: true })
                        .then(() => {
                            // The new custom claims will propagate to the user's ID token the
                            // next time a new one is issued.
                        });
                }
                else {
                    res.sendStatus(401);
                }
            })
                .catch((error) => {
                    res.status(500).send(error);
                });

        }
        else {
            res.status(400).json('No UID sent');
        }

    }
    else {
        res.sendStatus(401);
    }

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