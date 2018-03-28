import Test
import Stream

@testable import HTTP

class ServerTests: TestCase {
    func testServer() {
        guard let server = try? Server(host: "127.0.0.1", port: 4001) else {
            fail()
            return
        }

        server.route(get: "/test") {
            return Response(status: .ok)
        }

        let request = "GET /test HTTP/1.1\r\n\r\n"
        let inputStream = InputByteStream([UInt8](request.utf8))
        let outputStream = OutputByteStream()

        let byteStream = ByteStream(
            inputStream: inputStream,
            outputStream: outputStream)

        try? server.process(stream: byteStream)

        let expected = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n"
        let response = String(decoding: outputStream.bytes, as: UTF8.self)
        assertEqual(response, expected)
    }

    func testExpect() {
        guard let server = try? Server(host: "127.0.0.1", port: 4002) else {
            fail()
            return
        }

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

        try? server.process(stream: byteStream)

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
    }

    func testBufferSize() {
        scope {
            let server = try Server(
                host: "0.0.0.0",
                port: 4003)

            server.bufferSize = 16384
            assertEqual(server.bufferSize, 16384)
        }
    }

    func testDescription() {
        scope {
            let server = try Server(
                host: "127.0.0.1",
                port: 4004)

            assertEqual(server.address, "http://127.0.0.1:4004")
        }
    }
}
