import Log
import Async
import Network
import Foundation
import Buffer

@_exported import HTTP

public class Server {
    let socket: Socket
    public let host: String
    public let port: UInt16

    public var bufferSize = 1024

    var router = Router()

    public init(host: String, port: UInt16) throws {
        self.host = host
        self.port = port
        self.socket = try Socket()
    }

    convenience
    public init(host: String, reusePort: UInt16) throws {
        try self.init(host: host, port: reusePort)
        socket.configure(reusePort: true)
    }

    deinit {
        try? socket.close()
    }

    public func start() throws {
        try socket.bind(to: host, port: port).listen()
        log(event: .info, message: "\(self) started")
        async.task {
            while true {
                do {
                    let client = try self.socket.accept()
                    async.task { [unowned self] in
                        self.handleClient(client)
                    }
                } catch {
                    self.handleError(error)
                }
            }
        }
    }

    func handleClient(_ client: Socket) {
        do {
            let stream = NetworkStream(socket: client)
            let buffer = InputBuffer(capacity: bufferSize, source: stream)

            while true {
                let request = try Request(from: buffer)
                let response = router.handleRequest(request)
                _ = try client.send(bytes: response.bytes)
                if request.connection == .close {
                    break
                }
            }
        } catch {
            handleError(error)
        }
    }

    func handleError (_ error: Error) {
        if let error = error as? SocketError, error.number == ECONNRESET {
            /* connection reset by peer */
            /* do nothing, it's fine. */
        } else {
            log(event: .error, message: String(describing: error))
        }
    }
}
