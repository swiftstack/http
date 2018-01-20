extension Response {
    public enum Status {
        case ok
        case moved
        case `continue`
        case badRequest
        case unauthorized
        case notFound
        case conflict
        case internalServerError
    }
}
