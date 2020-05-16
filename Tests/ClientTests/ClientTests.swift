import Test
import Stream
import Network

@testable import HTTP

import struct Foundation.Data

extension OutputByteStream {
    var string: String {
        return String(decoding: bytes, as: UTF8.self)
    }
}

extension InputByteStream {
    convenience init(_ string: String) {
        self.init(ASCII(string))
    }
}

class ClientTests: TestCase {
    func testInitializer() {
        let client = HTTP.Client(host: "127.0.0.1", port: 80)
        expect(client.host == URL.Host(address: "127.0.0.1", port: 80))
    }

    func testURLInitializer() {
        guard let client = HTTP.Client(url: "http://127.0.0.1") else {
            fail()
            return
        }
        expect(client.host == URL.Host(address: "127.0.0.1", port: 80))
    }

    func testRequest() {
        scope {
            let requestString =
                "GET / HTTP/1.1\r\n" +
                "Host: 127.0.0.1:8080\r\n" +
                "User-Agent: swift-stack/http\r\n" +
                "Accept-Encoding: gzip, deflate\r\n" +
                "\r\n"

            let inputStream = InputByteStream("HTTP/1.1 200 OK\r\n\r\n")
            let input = BufferedInputStream(baseStream: inputStream)

            let outputStream = OutputByteStream()
            let output = BufferedOutputStream(baseStream: outputStream)

            let client = HTTP.Client(host: "127.0.0.1", port: 8080)
            let request = Request()

            let response = try client.makeRequest(request, input, output)
            expect(outputStream.string == requestString)
            expect(response.status == .ok)
        }
    }

    func testDeflate() {
        scope {
            let requestString =
                "GET / HTTP/1.1\r\n" +
                "Host: 127.0.0.1:8080\r\n" +
                "User-Agent: swift-stack/http\r\n" +
                "Accept-Encoding: gzip, deflate\r\n" +
                "\r\n"

            let deflateBase64 = "80jNycnXUQjPL8pJUQQA"
            let deflateBody = [UInt8](Data(base64Encoded: deflateBase64)!)
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

            let response = try client.makeRequest(request, input, output)
            expect(outputStream.string == requestString)
            expect(response.status == .ok)
            expect(response.contentEncoding == [.deflate])
            expect(response.string == "Hello, World!")
        }
    }

    func testGZip() {
        scope {
            let requestString =
                "GET / HTTP/1.1\r\n" +
                "Host: 127.0.0.1:8080\r\n" +
                "User-Agent: swift-stack/http\r\n" +
                "Accept-Encoding: gzip, deflate\r\n" +
                "\r\n"

            let gzipBase64 = "H4sIAAAAAAAAE/NIzcnJ11EIzy/KSVEEANDDSuwNAAAA"
            let gzipBody = [UInt8](Data(base64Encoded: gzipBase64)!)
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

            let response = try client.makeRequest(request, input, output)
            expect(outputStream.string == requestString)
            expect(response.status == .ok)
            expect(response.contentEncoding == [.gzip])
            expect(response.string == "Hello, World!")
        }
    }
}
