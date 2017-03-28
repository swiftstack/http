import XCTest
@testable import HTTP

struct NginxRequests {
    static let curlGet = "GET /test HTTP/1.1\r\nUser-Agent: curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1\r\nHost: 0.0.0.0=5000\r\nAccept: */*\r\n\r\n"

    static let firefoxGet =
        "GET /favicon.ico HTTP/1.1\r\nHost: 0.0.0.0=5000\r\nUser-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0\r\nAccept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\nAccept-Language: en-us,en;q=0.5\r\nAccept-Encoding: gzip,deflate\r\nAccept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\nKeep-Alive: 300\r\nConnection: keep-alive\r\n\r\n"

    static let chankedAllYourBase =
        "POST /post_chunked_all_your_base HTTP/1.1\r\nTransfer-Encoding: chunked\r\n\r\n1e\r\nall your base are belong to us\r\n0\r\n\r\n"
}

class NginxTests: TestCase {
    func testCurlGet() throws {
        let request = try Request(fromBytes: ASCII(NginxRequests.curlGet))
        assertNotNil(request.url)
        assertEqual(request.urlBytes, ASCII("/test"))
        assertEqual(request.url, "/test")
        assertEqual(request.version, .oneOne)
        assertEqual(request.host, "0.0.0.0=5000")
    }

    func testFirefoxGet() throws {
        let request = try Request(fromBytes: ASCII(NginxRequests.firefoxGet))
        assertNotNil(request.url)
        assertEqual(request.url, "/favicon.ico")
        assertEqual(request.urlBytes, ASCII("/favicon.ico"))
        assertEqual(request.version, .oneOne)
        assertEqual(request.host, "0.0.0.0=5000")
        assertEqual(request.userAgent, "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0")
        assertEqual(request.accept, "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
        assertEqual(request.acceptLanguage, "en-us,en;q=0.5")
        assertEqual(request.acceptEncoding, "gzip,deflate")
        assertEqual(request.acceptCharset, "ISO-8859-1,utf-8;q=0.7,*;q=0.7")
        assertEqual(request.keepAlive, 300)
        assertEqual(request.connection, "keep-alive")
    }

    func testChankedAllYourBase() throws {
        let request = try Request(fromBytes: ASCII(NginxRequests.chankedAllYourBase))
        assertEqual(request.transferEncoding, "chunked")
        assertEqual(request.body, "all your base are belong to us")
    }
}
