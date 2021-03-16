import Test
import Stream

@testable import HTTP

test.case("Server") {
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

    try? await server.process(
        inputStream: .init(baseStream: inputStream),
        outputStream: .init(baseStream: outputStream))

    let expected = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n"
    let response = outputStream.stringValue
    expect(response == expected)
}

test.case("Expect") {
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

    let inputStream = InputByteStream(request + body)
    let outputStream = OutputByteStream()

    try? await server.process(
        inputStream: .init(baseStream: inputStream),
        outputStream: .init(baseStream: outputStream))

    let expectedContinue =
        "HTTP/1.1 100 Continue\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let expectedResponse =
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: 0\r\n" +
        "\r\n"
    let expected = expectedContinue + expectedResponse
    let response = outputStream.stringValue
    expect(response == expected)
}

test.case("BufferSize") {
    let server = try Server(
        host: "0.0.0.0",
        port: 4003)

    server.bufferSize = 16384
    expect(server.bufferSize == 16384)
}

test.case("Description") {
    let server = try Server(
        host: "127.0.0.1",
        port: 4004)

    expect(server.address == "http://127.0.0.1:4004")
}

test.run()
