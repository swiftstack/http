import struct Foundation.CharacterSet

extension URL {
    func encode(to buffer: inout [UInt8]) {
        buffer.append(contentsOf: [UInt8](path.utf8))
        if query.values.count > 0 {
            buffer.append(.questionMark)
            query.encode(to: &buffer)
        }
        if let fragment = fragment {
            buffer.append(.hash)
            buffer.append(contentsOf: fragment.utf8)
        }
    }
}

extension URL.Query {
    public func encode(to buffer: inout [UInt8]) {
        let queryString = self.description
        buffer.append(contentsOf: queryString.utf8)
    }
}
