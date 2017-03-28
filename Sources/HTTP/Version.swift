public enum Version {
    case oneOne
}

extension Version {
    init(slice: ArraySlice<UInt8>) throws {
        guard slice.starts(with: Constants.httpSlash) else {
            throw RequestError.invalidVersion
        }
        let versionStart = slice.startIndex.advanced(by: Constants.httpSlash.count)
        let versionEnd = slice.index(versionStart, offsetBy: 3)
        let versionSlice = slice[versionStart..<versionEnd]
        if versionSlice.elementsEqual(Constants.oneOne) {
            self = .oneOne
        } else {
            throw RequestError.invalidVersion
        }
    }

    var bytes: [UInt8] {
        switch self {
        case .oneOne:
            return Constants.oneOne
        }
    }
}
