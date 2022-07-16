import URL
import Test
import Stream
import Network

@testable import HTTP

test.case("Initializer") {
    let client = HTTP.Client(host: "127.0.0.1", port: 80)
    expect(client.host == URL.Host(address: "127.0.0.1", port: 80))
}

test.case("URLInitializer") {
    guard let client = HTTP.Client(url: "http://127.0.0.1") else {
        fail()
        return
    }
    expect(client.host == URL.Host(address: "127.0.0.1", port: 80))
}

test.case("Request") {
    let requestString =
        "GET / HTTP/1.1\r\n" +
        "Host: 127.0.0.1:8080\r\n" +
        "User-Agent: swiftstack/http\r\n" +
        "Accept-Encoding: gzip, deflate\r\n" +
        "\r\n"

    let inputStream = InputByteStream("HTTP/1.1 200 OK\r\n\r\n")
    let input = BufferedInputStream(baseStream: inputStream)

    let outputStream = OutputByteStream()
    let output = BufferedOutputStream(baseStream: outputStream)

    let client = HTTP.Client(host: "127.0.0.1", port: 8080)
    let request = Request()

    let response = try await client.makeRequest(request, input, output)
    expect(outputStream.stringValue == requestString)
    expect(response.status == .ok)
}

test.case("Deflate") {
    let requestString =
        "GET / HTTP/1.1\r\n" +
        "Host: 127.0.0.1:8080\r\n" +
        "User-Agent: swiftstack/http\r\n" +
        "Accept-Encoding: gzip, deflate\r\n" +
        "\r\n"

    let deflateBody: [UInt8] = [
        0xf3, 0x48, 0xcd, 0xc9, 0xc9, 0xd7, 0x51, 0x08,
        0xcf, 0x2f, 0xca, 0x49, 0x51, 0x04, 0x00]
    let responseBytes = ASCII(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: \(deflateBody.count)\r\n" +
        "Content-Encoding: Deflate\r\n" +
        "\r\n") + deflateBody

    let inputStream = InputByteStream(responseBytes)
    let input = BufferedInputStream(baseStream: inputStream)

    let outputStream = OutputByteStream()
    let output = BufferedOutputStream(baseStream: outputStream)

    let client = HTTP.Client(host: "127.0.0.1", port: 8080)
    let request = Request()

    let response = try await client.makeRequest(request, input, output)
    expect(outputStream.stringValue == requestString)
    expect(response.status == .ok)
    expect(response.contentEncoding == [.deflate])
    expect(try await response.readBody() == ASCII("Hello, World!"))
}

test.case("GZip") {
    let requestString =
        "GET / HTTP/1.1\r\n" +
        "Host: 127.0.0.1:8080\r\n" +
        "User-Agent: swiftstack/http\r\n" +
        "Accept-Encoding: gzip, deflate\r\n" +
        "\r\n"

    let gzipBody: [UInt8] = [
        0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x13, 0xf3, 0x48, 0xcd, 0xc9, 0xc9, 0xd7,
        0x51, 0x08, 0xcf, 0x2f, 0xca, 0x49, 0x51, 0x04,
        0x00, 0xd0, 0xc3, 0x4a, 0xec, 0x0d, 0x00, 0x00,
        0x00]
    let responseBytes = ASCII(
        "HTTP/1.1 200 OK\r\n" +
        "Content-Length: \(gzipBody.count)\r\n" +
        "Content-Encoding: gzip\r\n" +
        "\r\n") + gzipBody

    let inputStream = InputByteStream(responseBytes)
    let input = BufferedInputStream(baseStream: inputStream)

    let outputStream = OutputByteStream()
    let output = BufferedOutputStream(baseStream: outputStream)

    let client = HTTP.Client(host: "127.0.0.1", port: 8080)
    let request = Request()

    let response = try await client.makeRequest(request, input, output)
    expect(outputStream.stringValue == requestString)
    expect(response.status == .ok)
    expect(response.contentEncoding == [.gzip])
    expect(try await response.readBody() == ASCII("Hello, World!"))
}

await test.run()
