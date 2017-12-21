import Log
import Async
import Network
import Stream
import Compression

// FIXME:
// linker issue on macOS
import struct Foundation.Date

@_exported import HTTP

public class Client {
    let host: URL.Host
    var stream: NetworkStream?
    var inputStream: BufferedInputStream<NetworkStream>?
    var outputStream: BufferedOutputStream<NetworkStream>?

    public var bufferSize = 4096

    public var isConnected: Bool {
        return stream != nil
    }

    public enum Compression {
        case none
        case gzip
        case deflate
    }

    public var compression: [Compression] = [.gzip, .deflate]
    public var userAgent: String? = "swift-stack/http"

    public init?(url: URL) {
        guard let host = url.host else {
            return nil
        }
        self.host = host
    }

    public init(host: String, port: Int) {
        self.host = URL.Host(address: host, port: port)
    }

    public func connect() throws {
        if isConnected {
            disconnect()
        }

        let port = host.port ?? 80
        let socket = try Socket()
        try socket.connect(to: host.address, port: port)

        self.stream = NetworkStream(socket: socket)
        self.inputStream = BufferedInputStream(
            baseStream: stream!, capacity: bufferSize)
        self.outputStream = BufferedOutputStream(
            baseStream: stream!, capacity: bufferSize)
    }

    public func disconnect() {
        self.stream = nil
        self.inputStream = nil
        self.outputStream = nil
    }

    public func makeRequest(_ request: Request) throws -> Response {
        if !isConnected {
            try connect()
        }

        var request = request
        updateHeaders(&request)

        var response: Response
        do {
            try request.encode(to: outputStream!)
            try outputStream!.flush()
            response = try Response(from: inputStream!)
        } catch {
            disconnect()
            throw error
        }
        try decode(&response)
        return response
    }

    private func updateHeaders(_ request: inout Request) {
        request.host = host
        if request.userAgent == nil, let userAgent = self.userAgent {
            request.userAgent = userAgent
        }
        updateAcceptEncoding(&request)
    }

    private func updateAcceptEncoding(_ request: inout Request) {
        guard !compression.isEmpty else {
            return
        }
        var acceptEncoding = request.acceptEncoding ?? []
        if compression.contains(.gzip) &&
            !acceptEncoding.contains(.gzip) {
                acceptEncoding.append(.gzip)
        }
        if compression.contains(.deflate) &&
            !acceptEncoding.contains(.deflate) {
                acceptEncoding.append(.deflate)
        }
        request.acceptEncoding = acceptEncoding
    }

    private func decode(_ response: inout Response) throws {
        guard let rawBody = response.rawBody,
            let contentEncoding = response.contentEncoding else {
                return
        }
        let stream = InputByteStream(rawBody)
        if contentEncoding.contains(.gzip) {
            response.rawBody = try GZip.decode(from: stream)
        } else if contentEncoding.contains(.deflate) {
            response.rawBody = try Inflate.decode(from: stream)
        }
    }
}

extension Client {
    private func makeRequest(
        method: Request.Method,
        path: String
    ) throws -> Response {
        return try makeRequest(Request(method: method, url: URL(path)))
    }

    public func get(path: String) throws -> Response {
        return try makeRequest(method: .get, path: path)
    }

    public func head(path: String) throws -> Response {
        return try makeRequest(method: .head, path: path)
    }

    public func post(path: String) throws -> Response {
        return try makeRequest(method: .post, path: path)
    }

    public func put(path: String) throws -> Response {
        return try makeRequest(method: .put, path: path)
    }

    public func delete(path: String) throws -> Response {
        return try makeRequest(method: .delete, path: path)
    }

    public func options(path: String) throws -> Response {
        return try makeRequest(method: .options, path: path)
    }
}

extension Client {
    public func post<T: Encodable>(
        path: String,
        object: T,
        contentType type: ApplicationSubtype = .json
    ) throws -> Response {
        let request = try Request(
            method: .post,
            url: URL(path),
            body: object,
            contentType: type)
        return try makeRequest(request)
    }
}
