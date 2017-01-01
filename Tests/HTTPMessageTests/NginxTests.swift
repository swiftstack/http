import XCTest
@testable import HTTPMessage

struct NginxHTTPRequests {
    static let curlGet = "GET /test HTTP/1.1\r\nUser-Agent: curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1\r\nHost: 0.0.0.0=5000\r\nAccept: */*\r\n\r\n"

    static let firefoxGet =
        "GET /favicon.ico HTTP/1.1\r\nHost: 0.0.0.0=5000\r\nUser-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\nAccept-Language: en-us,en;q=0.5\r\nAccept-Encoding: gzip,deflate\r\nAccept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\nKeep-Alive: 300\r\nConnection: keep-alive\r\n\r\n"

    static let chankedAllYourBase =
        "POST /post_chunked_all_your_base HTTP/1.1\r\nTransfer-Encoding: chunked\r\n\r\n1e\r\nall your base are belong to us\r\n0\r\n\r\n"
}

class NginxTests: XCTestCase {
    func testCurlGet() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(NginxHTTPRequests.curlGet))
        XCTAssertNotNil(httpRequest.url)
        XCTAssertEqual(httpRequest.urlBytes, ASCII("/test"))
        XCTAssertEqual(httpRequest.url, "/test")
        XCTAssertEqual(httpRequest.version, .oneOne)
        XCTAssertEqual(httpRequest.host, "0.0.0.0=5000")
    }

    func testFirefoxGet() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(NginxHTTPRequests.firefoxGet))
        XCTAssertNotNil(httpRequest.url)
        XCTAssertEqual(httpRequest.url, "/favicon.ico")
        XCTAssertEqual(httpRequest.urlBytes, ASCII("/favicon.ico"))
        XCTAssertEqual(httpRequest.version, .oneOne)
        XCTAssertEqual(httpRequest.host, "0.0.0.0=5000")
        XCTAssertEqual(httpRequest.userAgent, "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0")
        XCTAssertEqual(httpRequest.accept, "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
        XCTAssertEqual(httpRequest.acceptLanguage, "en-us,en;q=0.5")
        XCTAssertEqual(httpRequest.acceptEncoding, "gzip,deflate")
        XCTAssertEqual(httpRequest.acceptCharset, "ISO-8859-1,utf-8;q=0.7,*;q=0.7")
        XCTAssertEqual(httpRequest.keepAlive, 300)
        XCTAssertEqual(httpRequest.connection, "keep-alive")
    }

    func testChankedAllYourBase() throws {
        let httpRequest = try HTTPRequest(fromBytes: ASCII(NginxHTTPRequests.chankedAllYourBase))
        XCTAssertEqual(httpRequest.transferEncoding, "chunked")
        XCTAssertEqual(httpRequest.body, "all your base are belong to us")
    }
}
