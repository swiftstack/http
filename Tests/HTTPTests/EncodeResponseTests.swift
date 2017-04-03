@testable import HTTP

class EncodeResponseTests: TestCase {
    func testOk() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        assertEqual(response.status, .ok)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testNotFound() {
        let expected = "HTTP/1.1 404 Not Found\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .notFound)
        assertEqual(response.status, .notFound)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testMoved() {
        let expected = "HTTP/1.1 301 Moved Permanently\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .moved)
        assertEqual(response.status, .moved)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testBad() {
        let expected = "HTTP/1.1 400 Bad Request\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .badRequest)
        assertEqual(response.status, .badRequest)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testUnauthorized() {
        let expected = "HTTP/1.1 401 Unauthorized\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .unauthorized)
        assertEqual(response.status, .unauthorized)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testInternalServerError() {
        let expected = "HTTP/1.1 500 Internal Server Error\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .internalServerError)
        assertEqual(response.status, .internalServerError)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testVersion() {
        let response = Response(version: .oneOne)
        assertEqual(response.version, .oneOne)
    }

    func testContentType() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: text/plain\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        var response = Response()
        response.contentType = .text
        assertEqual(response.contentType, .text)
        assertEqual(response.contentLength, 0)
        assertEqual(String(bytes: response.bytes), expected)
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
        assertEqual(response.contentType, .text)
        assertEqual(response.contentLength, ASCII("Hello").count)
        assertEqual(String(bytes: response.bytes), expected)
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
        assertEqual(response.contentType, .html)
        assertEqual(response.contentLength, 13)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testBytesResponse() {
        let expected = ASCII("HTTP/1.1 200 OK\r\n" +
            "Content-Type: aplication/stream\r\n" +
            "Content-Length: 3\r\n" +
            "\r\n") + [1,2,3]
        let data: [UInt8] = [1,2,3]
        let response = Response(bytes: data)
        guard let rawBody = response.rawBody else {
            fail("body shouldn't be nil")
            return
        }
        assertEqual(rawBody, data)
        assertEqual(response.contentType, .stream)
        assertEqual(response.contentLength, 3)
        assertEqual(response.bytes, expected)
    }

    func testJsonResponse() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Type: application/json\r\n" +
            "Content-Length: 28\r\n" +
            "\r\n" +
            "{'message': 'Hello, World!'}"
        let response = Response(json: ASCII("{'message': 'Hello, World!'}"))
        guard let rawBody = response.rawBody,
            let body = response.body else {
                fail("body shouldn't be nil")
                return
        }
        assertEqual(body, "{'message': 'Hello, World!'}")
        assertEqual(rawBody, ASCII("{'message': 'Hello, World!'}"))
        assertEqual(response.contentType, .json)
        assertEqual(response.contentLength, 28)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testResponseHasContentLenght() {
        let expected = "HTTP/1.1 200 OK\r\n" +
            "Content-Length: 0\r\n" +
            "\r\n"
        let response = Response(status: .ok)
        assertEqual(response.status, .ok)
        assertEqual(String(bytes: response.bytes), expected)
    }
}
