import Log
import Async
import Socket
import Reflection
import HTTP

public enum ClientError: Error {
    case missingUrlHost
}

public class Client {
    let async: Async
    let socket: Socket

    var isConnected: Bool = false

    public init(async: Async) throws {
        self.async = async
        self.socket = try Socket(awaiter: async.awaiter)
    }

    deinit {
        try? socket.close()
    }

    public func connect(to url: URL) throws {
        guard let host = url.host else {
            throw ClientError.missingUrlHost
        }
        let port = url.port ?? 80

        if isConnected {
            try close()
        }

        try socket.connect(to: host, port: UInt16(port))
        isConnected = true
    }

    public func close() throws {
        isConnected = false
        try socket.close()
    }

    func send(_ request: Request) throws -> Response {
        if !isConnected {
            try connect(to: request.url)
        }
        var buffer = [UInt8](repeating: 0, count: 1500)
        do {
            _ = try socket.send(bytes: request.bytes)
            _ = try socket.receive(to: &buffer)
        } catch {
            try? close()
            throw error
        }
        return try Response(from: buffer)
    }
}

extension Client {
    public func get(_ url: String) throws -> Response {
        return try send(Request(method: .get, url: URL(url)))
    }

    public func head(_ url: String) throws -> Response {
        return try send(Request(method: .head, url: URL(url)))
    }

    public func post(_ url: String) throws -> Response {
        return try send(Request(method: .post, url: URL(url)))
    }

    public func put(_ url: String) throws -> Response {
        return try send(Request(method: .put, url: URL(url)))
    }

    public func delete(_ url: String) throws -> Response {
        return try send(Request(method: .delete, url: URL(url)))
    }

    public func options(_ url: String) throws -> Response {
        return try send(Request(method: .options, url: URL(url)))
    }
}

extension Client {
    public func post(_ url: String, json: [UInt8]) throws -> Response {
        var request = Request(method: .post, url: try URL(url))
        request.contentType = .json
        request.rawBody = json
        return try send(request)
    }
}
