import { NextFunction, Request, Response } from 'express';
import admin from './admin';

export const UserAuthMiddleware = (req: Request, res: Response, next: NextFunction) => {
    const err = new Error("not authorized");
    if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
        let authToken = req.headers.authorization.split(' ')[1];
        if (req.body.uid) {
            admin.auth().verifyIdToken(authToken).then((claims) => {
                next();
            })
                .catch((error) => {
                    next(error);
                });

        }
        else {
            next(err);
        }

    }
    else {
        next(err);
    }
}

export const AdminAuthMiddleware = (req: Request, res: Response, next: NextFunction) => {
    const err = new Error("not authorized");
    if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
        let authToken = req.headers.authorization.split(' ')[1];
        if (req.body.uid) {
            admin.auth().verifyIdToken(authToken).then((claims) => {
                if (claims.admin === true) {
                    next();
                }
                else {
                    next(err);
                }
            })
                .catch((error) => {
                    next(error);
                });

        }
        else {
            next(err);
        }

    }
    else {
        next(err);
    }
}



export const DriverAuthMiddleware = (req: Request, res: Response, next: NextFunction) => {
    const err = new Error("not authorized");
    if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
        let authToken = req.headers.authorization.split(' ')[1];
        if (req.body.uid) {
            admin.auth().verifyIdToken(authToken).then((claims) => {
                if (claims.driver === true) {
                    next();
                }
                else {
                    next(err);
                }
            })
                .catch((error) => {
                    next(error);
                });

        }
        else {
            next(err);
        }

    }
    else {
        next(err);
    }
}
