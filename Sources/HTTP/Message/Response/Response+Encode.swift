import Stream
import Network

extension Response {
    @_specialize(where T == BufferedOutputStream<TCP.Stream>)
    public func encode<T: StreamWriter>(to stream: T) async throws {
        // Start line
        try await version.encode(to: stream)
        try await stream.write(.whitespace)
        try await status.encode(to: stream)
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

        if let contentType = self.contentType {
            try await writeHeader(.contentType, encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            try await writeHeader(.contentLength, value: String(contentLength))
        }

        if let connection = self.connection {
            try await writeHeader(.connection, encoder: connection.encode)
        }

        if let contentEncoding = self.contentEncoding {
            try await writeHeader(.contentEncoding, encoder: contentEncoding.encode)
        }

        if let transferEncoding = self.transferEncoding {
            try await writeHeader(.transferEncoding, encoder: transferEncoding.encode)
        }

        for cookie in self.cookies {
            try await writeHeader(.setCookie, encoder: cookie.encode)
        }

        for (key, value) in headers {
            try await writeHeader(key, value: value)
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
