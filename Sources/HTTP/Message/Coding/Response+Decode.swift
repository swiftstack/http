import Stream
import Network

extension Response {
    @_specialize(where T == BufferedInputStream<NetworkStream>)
    public
    static func decode<T: StreamReader>(from stream: T) async throws -> Self {
        let response = Self()
        response.contentLength = nil
        do {
            response.version = try await Version.decode(from: stream)
            guard try await stream.consume(.whitespace) else {
                throw ParseError.invalidStartLine
            }

            response.status = try await Status.decode(from: stream)

            @inline(__always)
            func readLineEnd() async throws {
                guard try await stream.consume(.cr),
                      try await stream.consume(.lf) else
                {
                    throw ParseError.invalidResponse
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
                    throw ParseError.invalidResponse
                }
                try await stream.consume(while: { $0 == .whitespace })

                switch name {
                case .connection:
                    response.connection = try await Connection.decode(from: stream)
                case .contentEncoding:
                    response.contentEncoding = try await [ContentEncoding].decode(from: stream)
                case .contentLength:
                    response.contentLength = try await stream.parse(Int.self)
                case .contentType:
                    response.contentType = try await ContentType.decode(from: stream)
                case .transferEncoding:
                    response.transferEncoding = try await [TransferEncoding].decode(from: stream)
                case .setCookie:
                    response.cookies.append(try await Cookie.decode(responseCookieFrom: stream))
                default:
                    // FIXME: validate
                    response.headers[name] = try await stream.read(until: .cr) { bytes in
                        return String(decoding: bytes, as: UTF8.self)
                    }
                }

                try await readLineEnd()
            }

            // Body

            response.body = .input(stream)
            return response

        } catch let error as StreamError where error == .insufficientData {
            throw ParseError.unexpectedEnd
        }
    }
}
