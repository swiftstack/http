import Log
import Async
import Network
import Foundation
import Buffer

@_exported import HTTP

public class Server {
    let socket: Socket

    public var bufferSize = 4096

    var router = Router()

    public init(host: String, port: Int) throws {
        let socket = try Socket()
        try socket.bind(to: host, port: port)
        self.socket = socket
    }

    convenience
    public init(host: String, reusePort: Int) throws {
        try self.init(host: host, port: reusePort)
        try socket.options.set(.reusePort, true)
    }

    deinit {
        try? socket.close()
    }

    public func start() throws {
        try socket.listen()
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
            var stream = NetworkStream(socket: client)
            let buffer = InputBuffer(capacity: bufferSize, source: stream)

            while true {
                let request = try Request(from: buffer)
                let response = router.handleRequest(request)
                try response.encode(to: &stream)
                if request.connection == .close {
                    break
                }
            }
        } catch let error as HTTPError where error == .unexpectedEnd {
            /* connection closed */
        } catch let error as NetworkStream.Error where error == .closed {
            /* connection closed */
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
