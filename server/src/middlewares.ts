import { NextFunction, Request, Response } from 'express';
import admin from './admin';
import { AuthenticationError, HttpException } from './exceptions'

export const errorMiddleware = (error: HttpException, req: Request, res: Response, next: NextFunction) => {
    const status = error.status || 500;
    const message = error.message || 'Something went wrong';
    res
        .send({
            status,
            message,
        })
}

export const UserAuthMiddleware = (req: Request, res: Response, next: NextFunction) => {
    if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
        let authToken = req.headers.authorization.split(' ')[1];
        admin.auth().verifyIdToken(authToken).then((claims) => {
            next();
        })
            .catch((error) => {
                res.status(404);
                next(error);
            });


    }
    else {
        next(new AuthenticationError());
    }
}

export const AdminAuthMiddleware = (req: Request, res: Response, next: NextFunction) => {
    if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
        let authToken = req.headers.authorization.split(' ')[1];
        admin.auth().verifyIdToken(authToken).then((claims) => {
            if (claims.admin === true) {
                next();
            }
            else {
                next(new AuthenticationError());
            }
        })
            .catch((error) => {
                res.status(404);
                next(error);
            });


    }
    else {
        next(new AuthenticationError());
    }
}



export const DriverAuthMiddleware = (req: Request, res: Response, next: NextFunction) => {
    if (req.headers.authorization && req.headers.authorization.split(' ')[0] === 'Bearer') {
        let authToken = req.headers.authorization.split(' ')[1];
        admin.auth().verifyIdToken(authToken).then((claims) => {
            if (claims.driver === true) {
                next();
            }
            else {
                next(new AuthenticationError());
            }
        })
            .catch((error) => {
                next(error);
            });


    }
    else {
        next(new AuthenticationError());
    }
}
