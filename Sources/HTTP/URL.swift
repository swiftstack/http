public struct URL {
    public var path: String
    public var query: String
}

extension URL {
    init(_ url: String) {
        let view = url.utf8
        if var index = view.index(of: Character.questionMark) {
            self.path = String(view.prefix(upTo: index))!
            view.formIndex(after: &index)
            self.query = String(view.suffix(from: index))!
        } else {
            self.path = url
            self.query = ""
        }
    }
}

extension URL {
    init(from buffer: UnsafeRawBufferPointer) {
        if let index = buffer.index(of: Character.questionMark) {
            self.path = String(buffer: buffer.prefix(upTo: index))
            self.query = String(buffer: buffer.suffix(from: index + 1))
        } else {
            self.path = String(buffer: buffer)
            self.query = ""
        }
    }
}

extension URL: Equatable {
    public static func ==(lhs: URL, rhs: URL) -> Bool {
        return lhs.path == rhs.path && lhs.query == rhs.query
    }

    public static func ==(lhs: URL, rhs: String) -> Bool {
        return lhs.path + lhs.query == rhs
    }
}

extension URL: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(value)
    }
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(value)
    }
    public init(unicodeScalarLiteral value: String) {
        self.init(value)
    }
}
