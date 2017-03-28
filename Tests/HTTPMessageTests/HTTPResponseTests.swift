import XCTest
@testable import HTTPMessage

class HTTPResponseTests: TestCase {
    func testHTTPResponse() {
        let response = HTTPResponse()
        assertNotNil(response)
    }

    func testType() {
        let httpResponse: HTTPType = .response
        assertEqual(httpResponse, .response)
    }

    func testOk() {
        let expected = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n"
        let response = HTTPResponse(status: .ok)
        assertEqual(response.status, .ok)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testNotFound() {
        let expected = "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n"
        let response = HTTPResponse(status: .notFound)
        assertEqual(response.status, .notFound)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testMoved() {
        let expected =
            "HTTP/1.1 301 Moved Permanently\r\n" +
            "Content-Length: 0\r\n\r\n"
        let response = HTTPResponse(status: .moved)
        assertEqual(response.status, .moved)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testBad() {
        let expected = "HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\n\r\n"
        let response = HTTPResponse(status: .badRequest)
        assertEqual(response.status, .badRequest)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testUnauthorized() {
        let expected = "HTTP/1.1 401 Unauthorized\r\nContent-Length: 0\r\n\r\n"
        let response = HTTPResponse(status: .unauthorized)
        assertEqual(response.status, .unauthorized)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testInternalServerError() {
        let expected =
            "HTTP/1.1 500 Internal Server Error\r\n" +
            "Content-Length: 0\r\n\r\n"
        let response = HTTPResponse(status: .internalServerError)
        assertEqual(response.status, .internalServerError)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testHttpVersion() {
        let response = HTTPResponse(version: .oneOne)
        assertEqual(response.version, .oneOne)
    }

    func testContentType() {
        let expected =
            "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n" +
            "Content-Length: 0\r\n\r\n"
        var response = HTTPResponse()
        response.contentType = .text
        assertEqual(response.contentType, .text)
        assertEqual(response.contentLength, 0)
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testStringResponse() {
        let response = HTTPResponse(string: "Hello")
        guard let body = response.body else {
            fail("body shouldn't be nil")
            return
        }
        assertEqual(body, ASCII("Hello"))
        assertEqual(response.contentType, .text)
        assertEqual(response.contentLength, ASCII("Hello").count)
        let expected =
            "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n" +
            "Content-Length: 5\r\n\r\nHello"
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testHtmlResponse() {
        let response = HTTPResponse(html: "<html></html>")
        guard let body = response.body else {
            fail("body shouldn't be nil")
            return
        }
        assertEqual(body, ASCII("<html></html>"))
        assertEqual(response.contentType, .html)
        assertEqual(response.contentLength, 13)
        let expected =
            "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n" +
            "Content-Length: 13\r\n\r\n<html></html>"
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testBytesResponse() {
        let data: [UInt8] = [1,2,3]
        let response = HTTPResponse(bytes: data)
        guard let body = response.body else {
            fail("body shouldn't be nil")
            return
        }
        assertEqual(body, data)
        assertEqual(response.contentType, .stream)
        assertEqual(response.contentLength, 3)
        let expected = ASCII(
            "HTTP/1.1 200 OK\r\nContent-Type: aplication/stream\r\n" +
            "Content-Length: 3\r\n\r\n") + [1,2,3]
        assertEqual(response.bytes, expected)
    }

    func testJsonResponse() {
        let response = HTTPResponse(json: ASCII("{'message': 'Hello, World!'}"))
        guard let body = response.body else {
            fail("body shouldn't be nil")
            return
        }
        assertEqual(body, ASCII("{'message': 'Hello, World!'}"))
        assertEqual(response.contentType, .json)
        assertEqual(response.contentLength, 28)
        let expected =
            "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\n" +
            "Content-Length: 28\r\n\r\n{'message': 'Hello, World!'}"
        assertEqual(String(bytes: response.bytes), expected)
    }

    func testResponseHasContentLenght() {
        let expected = "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n"
        let response = HTTPResponse(status: .ok)
        assertEqual(response.status, .ok)
        assertEqual(String(bytes: response.bytes), expected)
    }
}
