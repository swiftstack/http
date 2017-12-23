import Test
import Stream
@testable import HTTP

import struct Foundation.Date

class ResponseDecodeBodyTests: TestCase {
    func testStringResponse() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/plain\r\n" +
                "Content-Length: 5\r\n" +
                "\r\n" +
                "Hello")
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .text(.plain)))
            assertEqual(response.contentLength, 5)
            guard let rawBody = response.rawBody else {
                fail("body is nil")
                return
            }
            assertEqual(rawBody, ASCII("Hello"))
            assertEqual(response.body, "Hello")
        } catch {
            fail(String(describing: error))
        }
    }

    func testHtmlResponse() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: text/html\r\n" +
                "Content-Length: 13\r\n" +
                "\r\n" +
                "<html></html>")
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .text(.html))
            )
            assertEqual(response.contentLength, 13)
            guard let rawBody = response.rawBody else {
                fail("body is nil")
                return
            }
            assertEqual(rawBody, ASCII("<html></html>"))
            assertEqual(response.body, "<html></html>")
        } catch {
            fail(String(describing: error))
        }
    }

    func testBytesResponse() {
        do {
            let bytes = ASCII(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/stream\r\n" +
                "Content-Length: 3\r\n" +
                "\r\n") + [1,2,3]
            let stream = InputByteStream(bytes)
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .application(.stream))
            )
            assertEqual(response.contentLength, 3)
            guard let rawBody = response.rawBody else {
                fail("body is nil")
                return
            }
            assertEqual(rawBody, [1,2,3] as [UInt8])
        } catch {
            fail(String(describing: error))
        }
    }

    func testJsonResponse() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Type: application/json\r\n" +
                "Content-Length: 28\r\n" +
                "\r\n" +
                "{'message': 'Hello, World!'}")
            let response = try Response(from: stream)
            assertEqual(
                response.contentType,
                ContentType(mediaType: .application(.json))
            )
            assertEqual(response.contentLength, 28)
            guard let rawBody = response.rawBody else {
                fail("body is nil")
                return
            }
            assertEqual(rawBody, ASCII("{'message': 'Hello, World!'}"))
            assertEqual(response.body, "{'message': 'Hello, World!'}")
        } catch {
            fail(String(describing: error))
        }
    }

    func testZeroContentLenght() {
        do {
            let stream = InputByteStream(
                "HTTP/1.1 200 OK\r\n" +
                "Content-Length: 0\r\n" +
                "\r\n")
            let response = try Response(from: stream)
            assertEqual(response.contentLength, 0)
            assertNil(response.rawBody)
            assertNil(response.body)
        } catch {
            fail(String(describing: error))
        }
    }
}
