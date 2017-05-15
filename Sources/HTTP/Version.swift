public enum Version {
    case oneOne
}

extension Version {
    init(from buffer: UnsafeRawBufferPointer) throws {
        guard buffer.starts(with: Constants.httpSlash) else {
            throw HTTPError.invalidVersion
        }
        guard buffer.count >= 8,
            buffer[5..<8].elementsEqual(Constants.oneOne) else {
                throw HTTPError.invalidVersion
        }
        self = .oneOne
    }
}

extension Version {
    func encode(to buffer: inout [UInt8]) {
        switch self {
        case .oneOne: buffer.append(contentsOf: Constants.oneOne)
        }
    }
}
