import Buffer
import MemoryStream

extension Request {
    // TODO: move to Tests?
    public init(from bytes: [UInt8]) throws {
        let stream = MemoryStream(capacity: bytes.count)
        _ = try stream.write(bytes)
        try stream.seek(to: 0, from: .begin)
        let inputBuffer = InputBuffer(source: stream)
        try self.init(from: inputBuffer)
    }

    public init<T: InputBufferProtocol>(from buffer: T) throws {
        guard let method = try buffer.read(until: Character.whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        self.method = try Request.Method(from: method)
        try buffer.consume(count: 1)

        guard let url = try buffer.read(until: Character.whitespace) else {
            throw HTTPError.unexpectedEnd
        }
        self.url = try URL(from: url)
        try buffer.consume(count: 1)

        guard let version = try buffer.read(until: Character.cr) else {
            throw HTTPError.unexpectedEnd
        }
        self.version = try Version(from: version)

        guard try buffer.read(count: 2).elementsEqual(Constants.lineEnd) else {
            throw HTTPError.invalidRequest
        }

        while buffer.peek(count: 2)?.starts(with: Constants.lineEnd) == false {
            guard let name = try buffer.read(until: Character.colon) else {
                throw HTTPError.unexpectedEnd
            }
            let headerName = try HeaderName(from: name)

            try buffer.consume(count: 1)

            guard let value = try buffer.read(until: Character.cr) else {
                throw HTTPError.unexpectedEnd
            }
            let headerValue = value.trimmingLeftSpace().trimmingRightSpace()

            guard try buffer.read(count: 2)
                .elementsEqual(Constants.lineEnd) else {
                    throw HTTPError.invalidRequest
            }

            switch headerName {
            case .host:
                self.host = String(validating: headerValue, as: .text)
            case .userAgent:
                self.userAgent = String(validating: headerValue, as: .text)
            case .accept:
                self.accept = try [Accept](from: headerValue)
            case .acceptLanguage:
                self.acceptLanguage =
                    try [AcceptLanguage](from: headerValue)
            case .acceptEncoding:
                self.acceptEncoding =
                    try [ContentEncoding](from: headerValue)
            case .acceptCharset:
                self.acceptCharset = try [AcceptCharset](from: headerValue)
            case .authorization:
                self.authorization = try Authorization(from: headerValue)
            case .keepAlive:
                self.keepAlive = Int(from: headerValue)
            case .connection:
                self.connection = try Connection(from: headerValue)
            case .contentLength:
                self.contentLength = Int(from: headerValue)
            case .contentType:
                self.contentType = try ContentType(from: headerValue)
            case .transferEncoding:
                self.transferEncoding =
                    try [TransferEncoding](from: headerValue)
            case .cookie:
                self.cookies.append(
                    contentsOf: try [Cookie](from: headerValue))
            default:
                headers[headerName] =
                    String(validating: headerValue, as: .text)
            }
        }

        guard buffer.count >= 2, try buffer.read(count: 2)
            .elementsEqual(Constants.lineEnd) else {
                throw HTTPError.unexpectedEnd
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

        while buffer.count >= Constants.minimumChunkLength {
            guard let sizeBytes = try buffer.read(until: Character.cr) else {
                throw HTTPError.unexpectedEnd
            }
            guard try buffer.read(count: 2)
                .elementsEqual(Constants.lineEnd) else {
                    throw HTTPError.invalidRequest
            }

            // TODO: optimize using hex table
            guard let size = Int(from: sizeBytes, radix: 16) else {
                throw HTTPError.invalidRequest
            }
            guard size > 0 else {
                break
            }

            // TODO: move the check?
            guard buffer.count >= size + 2 else {
                throw HTTPError.unexpectedEnd
            }

            let chunk = try buffer.read(count: size)
            guard try buffer.read(count: 2)
                .elementsEqual(Constants.lineEnd) else {
                    throw HTTPError.invalidRequest
            }

            body.append(contentsOf: chunk)
        }

        self.rawBody = body

        if buffer.count >= 2,
            buffer.peek(count: 2)!.elementsEqual(Constants.lineEnd) {
                try buffer.consume(count: 2)
        }
    }
}
