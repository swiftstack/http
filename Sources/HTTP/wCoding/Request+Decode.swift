import Stream
import Network

extension Request {
    @_specialize(exported: true, where T == BufferedInputStream<NetworkStream>)
    public init<T: UnsafeStreamReader>(from stream: T) throws {
        do {
            self.method = try Request.Method(from: stream)
            guard try stream.consume(.whitespace) else {
                throw ParseError.invalidStartLine
            }

            self.url = try URL(from: stream)
            guard try stream.consume(.whitespace) else {
                throw ParseError.invalidStartLine
            }

            self.version = try Version(from: stream)

            @inline(__always)
            func readLineEnd() throws {
                guard try stream.consume(.cr),
                    try stream.consume(.lf) else {
                        throw ParseError.invalidRequest
                }
            }

            try readLineEnd()

            while true {
                guard let nextLine = try stream.peek(count: 2) else {
                    throw ParseError.unexpectedEnd
                }
                if nextLine.elementsEqual(Constants.lineEnd) {
                    try stream.consume(count: 2)
                    break
                }

                let name = try HeaderName(from: stream)

                guard try stream.consume(.colon) else {
                    throw ParseError.invalidHeaderName
                }
                try stream.consume(while: { $0 == .whitespace })

                switch name {
                case .host:
                    guard self.url.host == nil else {
                        try stream.consume(until: .cr)
                        continue
                    }
                    self.host = try URL.Host(from: stream)
                case .userAgent:
                    // FIXME: validate
                    let bytes = try stream.read(until: .cr)
                    let trimmed = bytes.trimmingRightSpace()
                    self.userAgent = String(decoding: trimmed, as: UTF8.self)
                case .accept:
                    self.accept = try [Accept](from: stream)
                case .acceptLanguage:
                    self.acceptLanguage = try [AcceptLanguage](from: stream)
                case .acceptEncoding:
                    self.acceptEncoding = try [ContentEncoding](from: stream)
                case .acceptCharset:
                    self.acceptCharset = try [AcceptCharset](from: stream)
                case .authorization:
                    self.authorization = try Authorization(from: stream)
                case .keepAlive:
                    self.keepAlive = try Int(from: stream)
                case .connection:
                    self.connection = try Connection(from: stream)
                case .contentLength:
                    self.contentLength = try Int(from: stream)
                case .contentType:
                    self.contentType = try ContentType(from: stream)
                case .transferEncoding:
                    self.transferEncoding = try [TransferEncoding](from: stream)
                case .cookie:
                    self.cookies.append(contentsOf: try [Cookie](from: stream))
                default:
                    // FIXME: validate
                    let bytes = try stream.read(until: .cr)
                    let trimmed = bytes.trimmingRightSpace()
                    headers[name] = String(decoding: trimmed, as: UTF8.self)
                }

                try readLineEnd()
            }

            // Body

            // 1. content-lenght
            if let length = self.contentLength {
                guard length > 0 else {
                    self.rawBody = nil
                    return
                }
                self.rawBody = [UInt8](try stream.read(count: length))
                return
            }

            // 2. chunked
            guard let transferEncoding = self.transferEncoding,
                transferEncoding.contains(.chunked) else {
                    return
            }

            var body = [UInt8]()

            while true {
                let sizeBytes = try stream.read(until: .cr)
                try readLineEnd()

                // TODO: optimize using hex table
                guard let size = Int(from: sizeBytes, radix: 16) else {
                    throw ParseError.invalidRequest
                }
                guard size > 0 else {
                    try readLineEnd()
                    break
                }

                body.append(contentsOf: try stream.read(count: size))
                try readLineEnd()
            }

            self.rawBody = body

            // http request can have trailing \r\n
            // but we should avoid extra syscall
            if stream.buffered >= 2 {
                _ = try? stream.consume(sequence: Constants.lineEnd)
            }
        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}
