extension Server {
    public enum Error: Swift.Error {
        case notFound
        case conflict
        case internalServerError
    }
}
