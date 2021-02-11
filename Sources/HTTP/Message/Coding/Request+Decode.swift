import Stream
import Network

extension Request {
    @_specialize(where T == BufferedInputStream<NetworkStream>)
    public
    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        let request = Self()
        do {
            request.method = try await Request.Method.decode(from: stream)
            guard try await stream.consume(.whitespace) else {
                throw ParseError.invalidStartLine
            }

            request.url = try await URL.decode(from: stream)
            guard try await stream.consume(.whitespace) else {
                throw ParseError.invalidStartLine
            }

            request.version = try await Version.decode(from: stream)

            @inline(__always)
            func readLineEnd() async throws {
                guard try await stream.consume(.cr),
                      try await stream.consume(.lf) else
                {
                    throw ParseError.invalidRequest
                }
            }

            try await readLineEnd()

            while true {
                guard try await stream.cache(count: 2) else {
                    throw ParseError.unexpectedEnd
                }
                if try await stream.next(is: Constants.lineEnd) {
                    try await stream.consume(count: 2)
                    break
                }

                let name = try await HeaderName.decode(from: stream)

                guard try await stream.consume(.colon) else {
                    throw ParseError.invalidHeaderName
                }
                try await stream.consume(while: { $0 == .whitespace })

                switch name {
                case .host:
                    guard request.url.host == nil else {
                        try await stream.consume(until: .cr)
                        continue
                    }
                    request.host = try await URL.Host.decode(from: stream)
                case .userAgent:
                    // FIXME: validate
                    request.userAgent = try await stream.read(until: .cr) { bytes in
                        let trimmed = bytes.trimmingRightSpace()
                        return String(decoding: trimmed, as: UTF8.self)
                    }
                case .accept:
                    request.accept = try await [Accept].decode(from: stream)
                case .acceptLanguage:
                    request.acceptLanguage = try await [AcceptLanguage].decode(from: stream)
                case .acceptEncoding:
                    request.acceptEncoding = try await [ContentEncoding].decode(from: stream)
                case .acceptCharset:
                    request.acceptCharset = try await [AcceptCharset].decode(from: stream)
                case .authorization:
                    request.authorization = try await Authorization.decode(from: stream)
                case .keepAlive:
                    request.keepAlive = try await Int.decode(from: stream)
                case .connection:
                    request.connection = try await Connection.decode(from: stream)
                case .contentLength:
                    request.contentLength = try await Int.decode(from: stream)
                case .contentType:
                    request.contentType = try await ContentType.decode(from: stream)
                case .transferEncoding:
                    request.transferEncoding = try await [TransferEncoding].decode(from: stream)
                case .cookie:
                    request.cookies.append(contentsOf: try await [Cookie].decode(from: stream))
                case .expect:
                    request.expect = try await Expect.decode(from: stream)
                default:
                    // FIXME: validate
                    request.headers[name] = try await stream.read(until: .cr) { bytes in
                        return String(decoding: bytes, as: UTF8.self)
                    }
                }

                try await readLineEnd()
            }

            // Body

            request.body = .input(stream)
            return request

        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}
