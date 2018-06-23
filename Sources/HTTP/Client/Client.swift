import Log
import Async
import Network
import Stream
import Compression

public class Client {
    public var bufferSize = 4096
    var networkClient: Network.Client
    var stream: BufferedStream<NetworkStream>?

    public var isConnected: Bool {
        return networkClient.isConnected
    }

    var host: URL.Host {
        return URL.Host(address: networkClient.host, port: networkClient.port)
    }

    public enum Compression {
        case none
        case gzip
        case deflate
    }

    public var compression: [Compression] = [.gzip, .deflate]
    public var userAgent: String? = "swift-stack/http"

    public init(host: String, port: Int? = nil) {
        let port = port ?? 80
        self.networkClient = Network.Client(host: host, port: port)
    }

    public convenience init?(url: URL) {
        guard let host = url.host else {
            return nil
        }
        self.init(host: host.address, port: host.port)
    }

    public func connect() throws {
        guard !isConnected else {
            return
        }
        self.stream = try networkClient.connect()
    }

    public func disconnect() throws {
        self.stream = nil
        try networkClient.disconnect()
    }

    public func makeRequest(_ request: Request) throws -> Response {
        if !isConnected {
            try connect()
        }
        do {
            return try makeRequest(
                request,
                stream!.inputStream,
                stream!.outputStream)
        } catch {
            try? disconnect()
            throw error
        }
    }

    func makeRequest<I: InputStream, O: OutputStream>(
        _ request: Request,
        _ inputStream: BufferedInputStream<I>,
        _ outputStream: BufferedOutputStream<O>
    ) throws -> Response {
        var request = request
        updateHeaders(&request)
        try request.encode(to: outputStream)
        try outputStream.flush()

        var response = try Response(from: inputStream)
        try decode(&response)
        return response
    }

    private func updateHeaders(_ request: inout Request) {
        request.host = URL.Host(
            address: networkClient.host,
            port: networkClient.port)

        if request.userAgent == nil && self.userAgent != nil {
            request.userAgent = self.userAgent
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
        guard let bytes = response.bytes,
            let contentEncoding = response.contentEncoding else {
                return
        }
        let stream = InputByteStream(bytes)
        if contentEncoding.contains(.gzip) {
            response.bytes = try GZip.decode(from: stream)
        } else if contentEncoding.contains(.deflate) {
            response.bytes = try Inflate.decode(from: stream)
        }
    }
}

extension Client {
    private func makeRequest(
        method: Request.Method,
        path: String
    ) throws -> Response {
        return try makeRequest(Request(url: URL(path), method: method))
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
            url: URL(path),
            method: .post,
            body: object,
            contentType: type)
        return try makeRequest(request)
    }
}
