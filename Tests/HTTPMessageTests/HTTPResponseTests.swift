import XCTest
@testable import HTTPMessage

class HTTPResponseTests: XCTestCase {
    func testHTTPResponse() {
        let response = HTTPResponse()
        XCTAssertNotNil(response)
    }

    func testOk() {
        let response = HTTPResponse(status: .ok)
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(String(bytes: response.bytes), "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n")
    }

    func testNotFound() {
        let response = HTTPResponse(status: .notFound)
        XCTAssertEqual(response.status, .notFound)
        XCTAssertEqual(String(bytes: response.bytes), "HTTP/1.1 404 Not Found\r\nContent-Length: 0\r\n\r\n")
    }

    func testMoved() {
        let response = HTTPResponse(status: .moved)
        XCTAssertEqual(response.status, .moved)
        XCTAssertEqual(String(bytes: response.bytes), "HTTP/1.1 301 Moved Permanently\r\nContent-Length: 0\r\n\r\n")
    }

    func testBad() {
        let response = HTTPResponse(status: .badRequest)
        XCTAssertEqual(response.status, .badRequest)
        XCTAssertEqual(String(bytes: response.bytes), "HTTP/1.1 400 Bad Request\r\nContent-Length: 0\r\n\r\n")
    }

    func testUnauthorized() {
        let response = HTTPResponse(status: .unauthorized)
        XCTAssertEqual(response.status, .unauthorized)
        XCTAssertEqual(String(bytes: response.bytes), "HTTP/1.1 401 Unauthorized\r\nContent-Length: 0\r\n\r\n")
    }

    func testInternalServerError() {
        let response = HTTPResponse(status: .internalServerError)
        XCTAssertEqual(response.status, .internalServerError)
        XCTAssertEqual(String(bytes: response.bytes), "HTTP/1.1 500 Internal Server Error\r\nContent-Length: 0\r\n\r\n")
    }

    func testHttpVersion() {
        let response = HTTPResponse(version: .oneOne)
        XCTAssertEqual(response.version, .oneOne)
    }

    func testContentType() {
        var response = HTTPResponse()
        response.contentType = .text
        XCTAssertEqual(response.contentType, .text)
        XCTAssertEqual(response.contentLength, 0)
        let expected = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 0\r\n\r\n"
        XCTAssertEqual(String(bytes: response.bytes), expected)
    }

    func testStringResponse() {
        let response = HTTPResponse(string: "Hello")
        guard let body = response.body else {
            XCTFail("body shouldn't be nil")
            return
        }
        XCTAssertEqual(body, ASCII("Hello"))
        XCTAssertEqual(response.contentType, .text)
        XCTAssertEqual(response.contentLength, ASCII("Hello").count)
        let expected = "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: 5\r\n\r\nHello"
        XCTAssertEqual(String(bytes: response.bytes), expected)
    }

    func testHtmlResponse() {
        let response = HTTPResponse(html: "<html></html>")
        guard let body = response.body else {
            XCTFail("body shouldn't be nil")
            return
        }
        XCTAssertEqual(body, ASCII("<html></html>"))
        XCTAssertEqual(response.contentType, .html)
        XCTAssertEqual(response.contentLength, 13)
        let expected = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\nContent-Length: 13\r\n\r\n<html></html>"
        XCTAssertEqual(String(bytes: response.bytes), expected)
    }

    func testBytesResponse() {
        let data: [UInt8] = [1,2,3]
        let response = HTTPResponse(bytes: data)
        guard let body = response.body else {
            XCTFail("body shouldn't be nil")
            return
        }
        XCTAssertEqual(body, data)
        XCTAssertEqual(response.contentType, .stream)
        XCTAssertEqual(response.contentLength, 3)
        let expected = ASCII("HTTP/1.1 200 OK\r\nContent-Type: aplication/stream\r\nContent-Length: 3\r\n\r\n") + [1,2,3]
        XCTAssertEqual(response.bytes, expected)
    }

    func testJsonResponse() {
        let response = HTTPResponse(json: ASCII("{'message': 'Hello, World!'}"))
        guard let body = response.body else {
            XCTFail("body shouldn't be nil")
            return
        }
        XCTAssertEqual(body, ASCII("{'message': 'Hello, World!'}"))
        XCTAssertEqual(response.contentType, .json)
        XCTAssertEqual(response.contentLength, 28)
        let expected = "HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: 28\r\n\r\n{'message': 'Hello, World!'}"
        XCTAssertEqual(String(bytes: response.bytes), expected)
    }

    func testResponseHasContentLenght() {
        let response = HTTPResponse(status: .ok)
        XCTAssertEqual(response.status, .ok)
        XCTAssertEqual(String(bytes: response.bytes), "HTTP/1.1 200 OK\r\nContent-Length: 0\r\n\r\n")
    }
}
