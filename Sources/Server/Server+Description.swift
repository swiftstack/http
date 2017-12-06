extension Server: CustomStringConvertible {
    public var description: String {
        return "server at http://\(host)"
    }
}
