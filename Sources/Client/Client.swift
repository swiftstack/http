import Log
import Async
import Network
import Buffer

// FIXME:
// linker issue on macOS
import struct Foundation.Date

@_exported import HTTP

public enum ClientError: Error {
    case missingUrlHost
}

public class Client {
    let socket: Socket

    var isConnected: Bool = false

    public var bufferSize = 4096

    public init() throws {
        self.socket = try Socket()
    }

    deinit {
        try? socket.close()
    }

    public func connect(to url: URL) throws {
        guard let host = url.host else {
            throw ClientError.missingUrlHost
        }

        if isConnected {
            try close()
        }

        let port = host.port ?? 80
        try socket.connect(to: host.address, port: UInt16(port))
        isConnected = true
    }

    public func close() throws {
        isConnected = false
        try socket.close()
    }

    public func makeRequest(_ request: Request) throws -> Response {
        if !isConnected {
            try connect(to: request.url)
        }

        var stream = NetworkStream(socket: socket)
        let buffer = InputBuffer(capacity: bufferSize, source: stream)

        do {
            try request.encode(to: &stream)
            return try Response(from: buffer)
        } catch {
            try? close()
            throw error
        }
    }
}

extension Client {
    public func get(_ url: String) throws -> Response {
        return try makeRequest(Request(method: .get, url: URL(url)))
    }

    public func head(_ url: String) throws -> Response {
        return try makeRequest(Request(method: .head, url: URL(url)))
    }

    public func post(_ url: String) throws -> Response {
        return try makeRequest(Request(method: .post, url: URL(url)))
    }

    public func put(_ url: String) throws -> Response {
        return try makeRequest(Request(method: .put, url: URL(url)))
    }

    public func delete(_ url: String) throws -> Response {
        return try makeRequest(Request(method: .delete, url: URL(url)))
    }

    public func options(_ url: String) throws -> Response {
        return try makeRequest(Request(method: .options, url: URL(url)))
    }
}

extension Client {
    public func post<T: Encodable>(
        _ url: URL,
        json object: T
    ) throws -> Response {
        let request = try Request(method: .post, url: url, json: object)
        return try makeRequest(request)
    }

    public func post<T: Encodable>(
        _ url: URL,
        urlEncoded object: T
    ) throws -> Response {
        let request = try Request(method: .post, url: url, urlEncoded: object)
        return try makeRequest(request)
    }
}
