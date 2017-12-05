extension Server: CustomStringConvertible {
    public var description: String {
        let address: String
        switch socket.selfAddress {
        case .some(let selfAddress): address = "http://\(selfAddress)"
        case .none: address = "unknown"
        }
        return "server at \(address)"
    }
}
