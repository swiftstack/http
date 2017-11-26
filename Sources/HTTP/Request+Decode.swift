import Stream
import Buffer

extension Request {
    // TODO: move to Tests?
    public init(from bytes: [UInt8]) throws {
        let inputBuffer = InputBuffer(source: InputByteStream(bytes))
        try self.init(from: inputBuffer)
    }

    public init<T: InputBufferProtocol>(from buffer: T) throws {
        guard let method = try buffer.read(until: .whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        self.method = try Request.Method(from: method)
        try buffer.consume(count: 1)

        guard let url = try buffer.read(until: .whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        self.url = try URL(escaped: url)
        try buffer.consume(count: 1)

        guard let version = try buffer.read(until: .cr) else {
            throw HTTPError.unexpectedEnd
        }
        self.version = try Version(from: version)

        @inline(__always)
        func readLineEnd() throws {
            guard let lineEnd = try? buffer.read(count: 2) else {
                throw HTTPError.unexpectedEnd
            }
            guard lineEnd.elementsEqual(Constants.lineEnd) else {
                throw HTTPError.invalidRequest
            }
        }

        try readLineEnd()

        while true {
            guard let nameSlice = try buffer.read(while: {
                $0 != .colon && $0 != .lf
            }) else {
                throw HTTPError.unexpectedEnd
            }
            // "\r\n" found
            guard nameSlice.first != .cr else {
                try buffer.consume(count: 1)
                break
            }
            let name = try HeaderName(from: nameSlice)

            try buffer.consume(count: 1)

            guard var value = try buffer.read(until: .cr) else {
                throw HTTPError.unexpectedEnd
            }
            value = value.trimmingLeftSpace().trimmingRightSpace()

            try readLineEnd()

            switch name {
            case .host:
                self.host = String(validating: value, as: .text)
            case .userAgent:
                self.userAgent = String(validating: value, as: .text)
            case .accept:
                self.accept = try [Accept](from: value)
            case .acceptLanguage:
                self.acceptLanguage = try [AcceptLanguage](from: value)
            case .acceptEncoding:
                self.acceptEncoding = try [ContentEncoding](from: value)
            case .acceptCharset:
                self.acceptCharset = try [AcceptCharset](from: value)
            case .authorization:
                self.authorization = try Authorization(from: value)
            case .keepAlive:
                self.keepAlive = Int(from: value)
            case .connection:
                self.connection = try Connection(from: value)
            case .contentLength:
                self.contentLength = Int(from: value)
            case .contentType:
                self.contentType = try ContentType(from: value)
            case .transferEncoding:
                self.transferEncoding = try [TransferEncoding](from: value)
            case .cookie:
                self.cookies.append(contentsOf: try [Cookie](from: value))
            default:
                headers[name] = String(validating: value, as: .text)
            }
        }

        // Body

        // 1. content-lenght
        if let length = self.contentLength {
            guard length > 0 else {
                self.rawBody = nil
                return
            }
            self.rawBody = [UInt8](try buffer.read(count: length))
            return
        }

        // 2. chunked
        guard let transferEncoding = self.transferEncoding,
            transferEncoding.contains(.chunked) else {
                return
        }

        var body = [UInt8]()

        while true {
            guard let sizeBytes = try buffer.read(until: .cr) else {
                throw HTTPError.unexpectedEnd
            }
            try readLineEnd()

            // TODO: optimize using hex table
            guard let size = Int(from: sizeBytes, radix: 16) else {
                throw HTTPError.invalidRequest
            }
            guard size > 0 else {
                break
            }

            body.append(contentsOf: try buffer.read(count: size))
            try readLineEnd()
        }

        self.rawBody = body

        if buffer.count >= 2,
            buffer.peek(count: 2)!.elementsEqual(Constants.lineEnd) {
                try buffer.consume(count: 2)
        }
    }
}
