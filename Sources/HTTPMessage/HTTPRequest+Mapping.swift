extension HTTPRequestType {
    init(slice: ArraySlice<UInt8>) throws {
        for (type, bytes) in RequestTypeMapping.values {
            if slice.elementsEqual(bytes) {
                self = type
                return
            }
        }
        throw HTTPRequestError.invalidMethod
    }
}

fileprivate struct RequestTypeMapping {
    static let values: [(HTTPRequestType, ASCII)] = [
        (.get, ASCII("GET")),
        (.head, ASCII("HEAD")),
        (.post, ASCII("POST")),
        (.put, ASCII("PUT")),
        (.delete, ASCII("DELETE"))
    ]
}
