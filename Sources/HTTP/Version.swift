import Stream

public enum Version {
    case oneOne
}

extension Version {
    private struct Bytes {
        static let httpSlash = ASCII("HTTP/")
        static let oneOne = ASCII("1.1")
    }

    init<T: UnsafeStreamReader>(from stream: T) throws {
        let prefix = try stream.read(count: Bytes.httpSlash.count)
        guard prefix.elementsEqual(Bytes.httpSlash) else {
            throw HTTPError.invalidVersion
        }
        let varsionBytes = try stream.read(count: Bytes.oneOne.count)
        guard varsionBytes.elementsEqual(Bytes.oneOne) else {
            throw HTTPError.invalidVersion
        }
        self = .oneOne
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        try stream.write(Bytes.httpSlash)
        switch self {
        case .oneOne: try stream.write(Bytes.oneOne)
        }
    }
}
