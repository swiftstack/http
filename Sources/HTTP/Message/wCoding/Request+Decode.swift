import Stream
import Network

extension Request {
    @_specialize(exported: true, where T == BufferedInputStream<NetworkStream>)
    public convenience init<T: StreamReader>(from stream: T) throws {
        self.init()
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
                guard try stream.cache(count: 2) else {
                    throw ParseError.unexpectedEnd
                }
                if try stream.next(is: Constants.lineEnd) {
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
                    self.userAgent = try stream.read(until: .cr) { bytes in
                        let trimmed = bytes.trimmingRightSpace()
                        return String(decoding: trimmed, as: UTF8.self)
                    }
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
                case .expect:
                    self.expect = try Expect(from: stream)
                default:
                    // FIXME: validate
                    headers[name] = try stream.read(until: .cr) { bytes in
                        return String(decoding: bytes, as: UTF8.self)
                    }
                }

                try readLineEnd()
            }

            // Body

            self.body = .input(stream)

        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}
