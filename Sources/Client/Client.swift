import Log
import Async
import Network
import Buffer
import Stream
import Compression

// FIXME:
// linker issue on macOS
import struct Foundation.Date

@_exported import HTTP

public class Client {
    let host: URL.Host
    var stream: NetworkStream?
    var inputBuffer: InputBuffer<NetworkStream>?

    public var bufferSize = 4096

    public var isConnected: Bool {
        return stream != nil
    }

    public enum Compression {
        case none
        case deflate
    }

    public var compression: Compression = .deflate

    public init(host: String, port: Int) throws {
        self.host = URL.Host(address: host, port: port)
    }

    public func connect() throws {
        if isConnected {
            disconnect()
        }

        let port = host.port ?? 80
        let socket = try Socket()
        try socket.connect(to: host.address, port: UInt16(port))

        self.stream = NetworkStream(socket: socket)
        self.inputBuffer = InputBuffer(capacity: bufferSize, source: stream!)
    }

    public func disconnect() {
        self.stream = nil
        self.inputBuffer = nil
    }

    public func makeRequest(_ request: Request) throws -> Response {
        if !isConnected {
            try connect()
        }

        var request = request
        updateAcceptEncoding(&request)

        var response: Response
        do {
            try request.encode(to: &stream!)
            response = try Response(from: inputBuffer!)
        } catch {
            disconnect()
            throw error
        }
        try inflate(&response)
        return response
    }

    private func updateAcceptEncoding(_ request: inout Request) {
        if compression == .deflate {
            var acceptEncoding = request.acceptEncoding ?? []
            if !acceptEncoding.contains(.deflate) {
                acceptEncoding.append(.deflate)
                request.acceptEncoding = acceptEncoding
            }
        }
    }

    private func inflate(_ response: inout Response) throws {
        if let rawBody = response.rawBody,
            let contentEncoding = response.contentEncoding,
            contentEncoding.contains(.deflate) {
            let byteStream = InputByteStream(rawBody)
            response.rawBody = try Inflate.decode(from: byteStream)
        }
    }
}

extension Client {
    public func get(path: String) throws -> Response {
        return try makeRequest(Request(method: .get, url: URL(path)))
    }

    public func head(path: String) throws -> Response {
        return try makeRequest(Request(method: .head, url: URL(path)))
    }

    public func post(path: String) throws -> Response {
        return try makeRequest(Request(method: .post, url: URL(path)))
    }

    public func put(path: String) throws -> Response {
        return try makeRequest(Request(method: .put, url: URL(path)))
    }

    public func delete(path: String) throws -> Response {
        return try makeRequest(Request(method: .delete, url: URL(path)))
    }

    public func options(path: String) throws -> Response {
        return try makeRequest(Request(method: .options, url: URL(path)))
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
