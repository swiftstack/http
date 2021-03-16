import Log
import URL
import Network
import Stream
import DCompression

public class Client {
    public var bufferSize = 4096
    var tcpClient: Network.TCP.Client
    var stream: BufferedStream<TCP.Stream>?

    public var isConnected: Bool {
        return tcpClient.isConnected
    }

    var host: URL.Host {
        return URL.Host(address: tcpClient.host, port: tcpClient.port)
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
        self.tcpClient = Network.TCP.Client(host: host, port: port)
    }

    public convenience init?(url: URL) {
        guard let host = url.host else {
            return nil
        }
        self.init(host: host.address, port: host.port)
    }

    public func connect() async throws {
        guard !isConnected else {
            return
        }
        let tcpStream = try await tcpClient.connect()
        self.stream = BufferedStream(baseStream: tcpStream)
    }

    public func disconnect() throws {
        stream = nil
        try tcpClient.disconnect()
    }

    public func makeRequest(_ request: Request) async throws -> Response {
        if !isConnected {
            try await connect()
        }
        do {
            return try await makeRequest(
                request,
                stream!.inputStream,
                stream!.outputStream)
        } catch {
            try? disconnect()
            throw error
        }
    }

    func makeRequest<I: StreamReader, O: StreamWriter>(
        _ request: Request,
        _ inputStream: I,
        _ outputStream: O
    ) async throws -> Response {
        var request = request
        updateHeaders(&request)
        try await request.encode(to: outputStream)
        try await outputStream.flush()

        var response = try await Response.decode(from: inputStream)
        try await decode(&response)
        return response
    }

    private func updateHeaders(_ request: inout Request) {
        request.host = URL.Host(
            address: tcpClient.host,
            port: tcpClient.port)

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

    private func decode(_ response: inout Response) async throws {
        guard let bytes = response.bytes,
            let contentEncoding = response.contentEncoding else {
                return
        }
        let stream = InputByteStream(bytes)
        if contentEncoding.contains(.gzip) {
            response.bytes = try await GZip.decode(from: stream)
        } else if contentEncoding.contains(.deflate) {
            response.bytes = try await Deflate.decode(from: stream)
        }
    }
}

extension Client {
    private func makeRequest(
        method: Request.Method,
        path: String
    ) async throws -> Response {
        return try await makeRequest(Request(url: URL(path), method: method))
    }

    public func get(path: String) async throws -> Response {
        return try await makeRequest(method: .get, path: path)
    }

    public func head(path: String) async throws -> Response {
        return try await makeRequest(method: .head, path: path)
    }

    public func post(path: String) async throws -> Response {
        return try await makeRequest(method: .post, path: path)
    }

    public func put(path: String) async throws -> Response {
        return try await makeRequest(method: .put, path: path)
    }

    public func delete(path: String) async throws -> Response {
        return try await makeRequest(method: .delete, path: path)
    }

    public func options(path: String) async throws -> Response {
        return try await makeRequest(method: .options, path: path)
    }
}

extension Client {
    public func post<T: Encodable>(
        path: String,
        object: T,
        contentType type: ApplicationSubtype = .json
    ) async throws -> Response {
        let request = try Request(
            url: URL(path),
            method: .post,
            body: object,
            contentType: type)
        return try await makeRequest(request)
    }
}
