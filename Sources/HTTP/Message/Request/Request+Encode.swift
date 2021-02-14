import URL
import Stream
import Network

extension Request {
    @_specialize(where T == BufferedOutputStream<NetworkStream>)
    public func encode<T: StreamWriter>(to stream: T) async throws {
        // Start Line
        try await method.encode(to: stream)
        try await stream.write(.whitespace)
        try await url.encode(\URL.path, to: stream)
        if method == .get {
            try await url.encode(\URL.query, to: stream)
        }
        try await stream.write(.whitespace)
        try await version.encode(to: stream)
        try await stream.write(Constants.lineEnd)

        // Headers
        @inline(__always)
        func writeHeader(
            _ name: HeaderName,
            encoder: (T) async throws -> Void
        ) async throws {
            try await stream.write(name.bytes)
            try await stream.write(.colon)
            try await stream.write(.whitespace)
            try await encoder(stream)
            try await stream.write(Constants.lineEnd)
        }

        @inline(__always)
        func writeHeader(_ name: HeaderName, value: String) async throws {
            try await writeHeader(name) { stream in
                try await stream.write(value)
            }
        }

        if let host = self.host {
            try await writeHeader(.host, encoder: host.encode)
        }

        if let contentType = self.contentType {
            try await writeHeader(.contentType, encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            try await writeHeader(.contentLength, value: String(contentLength))
        }

        if let userAgent = self.userAgent {
            try await writeHeader(.userAgent, value: userAgent)
        }

        if let accept = self.accept {
            try await writeHeader(.accept, encoder: accept.encode)
        }

        if let acceptLanguage = self.acceptLanguage {
            try await writeHeader(.acceptLanguage, encoder: acceptLanguage.encode)
        }

        if let acceptEncoding = self.acceptEncoding {
            try await writeHeader(.acceptEncoding, encoder: acceptEncoding.encode)
        }

        if let acceptCharset = self.acceptCharset {
            try await writeHeader(.acceptCharset, encoder: acceptCharset.encode)
        }

        if let authorization = self.authorization {
            try await writeHeader(.authorization, encoder: authorization.encode)
        }

        if let keepAlive = self.keepAlive {
            try await writeHeader(.keepAlive, value: String(keepAlive))
        }

        if let connection = self.connection {
            try await writeHeader(.connection, encoder: connection.encode)
        }

        if let transferEncoding = self.transferEncoding {
            try await writeHeader(.transferEncoding, encoder: transferEncoding.encode)
        }

        for (key, value) in headers {
            try await writeHeader(key, value: value)
        }

        // Cookies
        for cookie in cookies {
            try await writeHeader(.cookie, encoder: cookie.encode)
        }

        // Separator
        try await stream.write(Constants.lineEnd)

        // Body
        switch body {
        case .bytes(let bytes): try await stream.write(bytes)
        // TODO:
        // case .output(let writer): try writer(stream)
        default: break
        }
    }
}
