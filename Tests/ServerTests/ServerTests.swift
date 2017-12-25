import Test
import Stream
import Dispatch
import AsyncDispatch

@testable import Server

class ServerTests: TestCase {
    override func setUp() {
        AsyncDispatch().registerGlobal()
    }

    func testServer() {
        do {
            let server = try Server(host: "127.0.0.1", port: 4001)

            server.route(get: "/test") {
                return Response(status: .ok)
            }

            let request = "GET /test HTTP/1.1\r\n\r\n"
            let inputStream = InputByteStream([UInt8](request.utf8))
            let outputStream = OutputByteStream()

            let byteStream = ByteStream(
                inputStream: inputStream,
                outputStream: outputStream)

            server.handleClient(stream: byteStream)

            let expected = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n"
            let response = String(decoding: outputStream.bytes, as: UTF8.self)
            assertEqual(response, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testExpect() {
        do {
            let server = try Server(host: "127.0.0.1", port: 4002)

            struct User: Decodable {
                let name: String
            }

            server.route(post: "/test") { (user: User) in
                return Response(status: .ok)
            }

            let request =
                "POST /test HTTP/1.1\r\n" +
                "Content-Length: 9\r\n" +
                "Content-Type: application/x-www-form-urlencoded\r\n" +
                "Expect: 100-continue\r\n" +
                "\r\n"
            let body = "name=tony"

            let input = [UInt8](request.utf8) + [UInt8](body.utf8)
            let inputStream = InputByteStream(input)
            let outputStream = OutputByteStream()

            let byteStream = ByteStream(
                inputStream: inputStream,
                outputStream: outputStream)

            server.handleClient(stream: byteStream)

            let expectedContinue =
                "HTTP/1.1 100 Continue\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n"
            let expectedResponse =
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n"
            let expected = expectedContinue + expectedResponse

            let response = String(decoding: outputStream.bytes, as: UTF8.self)
            assertEqual(response, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testBufferSize() {
        do {
            let server = try Server(
                host: "0.0.0.0",
                port: 4003)

            server.bufferSize = 16384
            assertEqual(server.bufferSize, 16384)
        } catch {
            fail(String(describing: error))
        }
    }

    func testDescription() {
        do {
            let server = try Server(
                host: "127.0.0.1",
                port: 4004)

            assertEqual(server.description, "server at http://127.0.0.1:4004")
        } catch {
            fail(String(describing: error))
        }
    }
}
