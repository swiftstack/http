import Test
import Stream
@testable import HTTP

import struct Foundation.Date

class ResponseEncodeBodyTests: TestCase {
    func testStringResponse() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/plain\r\n" +
            "Content-Length: 5\r\n" +
            "\r\n" +
            "Hello"
        let response = Response(string: "Hello")
        assertEqual(response.string, "Hello")
        assertEqual(response.bytes, ASCII("Hello"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .text(.plain))
        )
        assertEqual(response.contentLength, ASCII("Hello").count)
        assertEqual(try response.encode(), expected)
    }

    func testHtmlResponse() {
        let expected =
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/html\r\n" +
            "Content-Length: 13\r\n" +
            "\r\n" +
            "<html></html>"
        let response = Response(html: "<html></html>")
        assertEqual(response.string, "<html></html>")
        assertEqual(response.bytes, ASCII("<html></html>"))
        assertEqual(response.contentType, .html)
        assertEqual(response.contentLength, 13)
        assertEqual(try response.encode(), expected)
    }

    func testBytesResponse() {
        let expected = ASCII(
            "HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/stream\r\n" +
            "Content-Length: 3\r\n" +
            "\r\n") + [1,2,3]
        let data: [UInt8] = [1,2,3]
        let response = Response(bytes: data)
        assertEqual(response.bytes, data)
        assertEqual(response.contentType, .stream)
        assertEqual(response.contentLength, 3)
        assertEqual(ASCII(try response.encode()), expected)
    }

    func testJsonResponse() {
        scope {
            let expected =
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/json\r\n" +
                "Content-Length: 27\r\n" +
                "\r\n" +
                "{\"message\":\"Hello, World!\"}"

            let response = try Response(body: ["message" : "Hello, World!"])

            let body = "{\"message\":\"Hello, World!\"}"
            assertEqual(response.string, body)
            assertEqual(response.bytes, ASCII(body))
            assertEqual(response.contentType, .json)
            assertEqual(response.contentLength, 27)
            assertEqual(try response.encode(), expected)
        }
    }

    func testUrlFormEncodedResponse() {
        scope {
            let expected =
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/x-www-form-urlencoded\r\n" +
                "Content-Length: 23\r\n" +
                "\r\n" +
                "message=Hello,%20World!"

            let response = try Response(
                body: ["message" : "Hello, World!"],
                contentType: .formURLEncoded)

            assertEqual(response.string, "message=Hello,%20World!")
            assertEqual(response.bytes, ASCII("message=Hello,%20World!"))
            assertEqual(response.contentType, .formURLEncoded)
            assertEqual(response.contentLength, 23)
            assertEqual(try response.encode(), expected)
        }
    }
}
