export class HttpException extends Error {
    status: number;
    message: string;
    constructor(status: number, message: string) {
        super(message);
        this.status = status;
        this.message = message;
    }
}

export class AuthenticationError extends HttpException {
    constructor() {
        super(404,'Not Authorized');
    }
}