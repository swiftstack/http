import Test
import Stream
@testable import HTTP

import struct Foundation.Date

class ResponseEncodeBodyTests: TestCase {
    class Encoder {
        static func encode(_ response: Response) -> String? {
            let stream = OutputByteStream()
            try? response.encode(to: stream)
            return String(decoding: stream.bytes, as: UTF8.self)
        }
    }

    func testStringResponse() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/plain\r\n" +
            "Content-Length: 5\r\n" +
            "\r\n" +
            "Hello"
        let response = Response(string: "Hello")
        guard let rawBody = response.rawBody,
            let body = response.body else {
                fail("body shouldn't be nil")
                return
        }
        assertEqual(body, "Hello")
        assertEqual(rawBody, ASCII("Hello"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .text(.plain))
        )
        assertEqual(response.contentLength, ASCII("Hello").count)
        assertEqual(Encoder.encode(response), expected)
    }

    func testHtmlResponse() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/html\r\n" +
            "Content-Length: 13\r\n" +
            "\r\n" +
            "<html></html>"
        let response = Response(html: "<html></html>")
        guard let rawBody = response.rawBody,
            let body = response.body else {
                fail("body shouldn't be nil")
                return
        }
        assertEqual(body, "<html></html>")
        assertEqual(rawBody, ASCII("<html></html>"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .text(.html))
        )
        assertEqual(response.contentLength, 13)
        assertEqual(Encoder.encode(response), expected)
    }

    func testBytesResponse() {
        let expected = ASCII("HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/stream\r\n" +
            "Content-Length: 3\r\n" +
            "\r\n") + [1,2,3]
        let data: [UInt8] = [1,2,3]
        let response = Response(bytes: data)
        guard let rawBody = response.rawBody else {
            fail("body shouldn't be nil")
            return
        }
        assertEqual(rawBody, data)
        assertEqual(
            response.contentType,
            ContentType(mediaType: .application(.stream))
        )
        assertEqual(response.contentLength, 3)
        assertEqual(ASCII(Encoder.encode(response) ?? ""), expected)
    }

    func testJsonResponse() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/json\r\n" +
            "Content-Length: 27\r\n" +
            "\r\n" +
            "{\"message\":\"Hello, World!\"}"
        guard let response = try? Response(
            body: ["message" : "Hello, World!"]),
            let rawBody = response.rawBody,
            let body = response.body else {
                fail("body shouldn't be nil")
                return
        }
        assertEqual(body, "{\"message\":\"Hello, World!\"}")
        assertEqual(rawBody, ASCII("{\"message\":\"Hello, World!\"}"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .application(.json))
        )
        assertEqual(response.contentLength, 27)
        assertEqual(Encoder.encode(response), expected)
    }

    func testUrlEncodedResponse() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/x-www-form-urlencoded\r\n" +
            "Content-Length: 23\r\n" +
            "\r\n" +
            "message=Hello,%20World!"
        guard let response = try? Response(
            body: ["message" : "Hello, World!"],
            contentType: .urlEncoded),
            let rawBody = response.rawBody,
            let body = response.body else {
                fail("body shouldn't be nil")
                return
        }
        assertEqual(body, "message=Hello,%20World!")
        assertEqual(rawBody, ASCII("message=Hello,%20World!"))
        assertEqual(
            response.contentType,
            ContentType(mediaType: .application(.urlEncoded))
        )
        assertEqual(response.contentLength, 23)
        assertEqual(Encoder.encode(response), expected)
    }
}
