import Stream
import Network

extension Response {
    @_specialize(exported: true, where T == NetworkStream)
    public func encode<T: OutputStream>(
        to stream: BufferedOutputStream<T>
    ) throws {
        // Start line
        try version.encode(to: stream)
        try stream.write(.whitespace)
        try status.encode(to: stream)
        try stream.write(Constants.lineEnd)

        // Headers
        @inline(__always)
        func writeHeader(
            _ name: HeaderName,
            encoder: (BufferedOutputStream<T>) throws -> Void
        ) throws {
            try stream.write(name.bytes)
            try stream.write(.colon)
            try stream.write(.whitespace)
            try encoder(stream)
            try stream.write(Constants.lineEnd)
        }

        @inline(__always)
        func writeHeader(_ name: HeaderName, value: String) throws {
            try writeHeader(name) { stream in
                try stream.write(value)
            }
        }

        if let contentType = self.contentType {
            try writeHeader(.contentType, encoder: contentType.encode)
        }

        if let contentLength = self.contentLength {
            try writeHeader(.contentLength, value: String(contentLength))
        }

        if let connection = self.connection {
            try writeHeader(.connection, encoder: connection.encode)
        }

        if let contentEncoding = self.contentEncoding {
            try writeHeader(.contentEncoding, encoder: contentEncoding.encode)
        }

        if let transferEncoding = self.transferEncoding {
            try writeHeader(.transferEncoding, encoder: transferEncoding.encode)
        }

        for cookie in self.setCookie {
            try writeHeader(.setCookie, encoder: cookie.encode)
        }

        for (key, value) in headers {
            try writeHeader(key, value: value)
        }

        // Separator
        guard try stream.write(Constants.lineEnd) ==
            Constants.lineEnd.count else {
                throw StreamError.notEnoughSpace
        }

        // Body
        if let rawBody = rawBody {
            guard try stream.write(rawBody) == rawBody.count else {
                throw StreamError.notEnoughSpace
            }
        }
    }
}
