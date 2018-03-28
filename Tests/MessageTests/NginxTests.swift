import Test
import Stream
@testable import HTTP

class NginxTests: TestCase {
    func testCurlGet() {
        scope {
            let stream = InputByteStream(
                "GET /test HTTP/1.1\r\n" +
                "User-Agent: curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1\r\n" +
                "Host: 0.0.0.0:5000\r\n" +
                "Accept: */*\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            assertNotNil(request.url)
            assertEqual(request.url.path, "/test")
            assertEqual(request.url, "0.0.0.0:5000/test")
            assertEqual(request.version, .oneOne)
            assertEqual(request.userAgent, "curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1")
            assertEqual(request.host, URL.Host(address: "0.0.0.0", port: 5000))
        }
    }

    func testFirefoxGet() {
        scope {
            let stream = InputByteStream(
                "GET /favicon.ico HTTP/1.1\r\n" +
                "Host: 0.0.0.0:5000\r\n" +
                "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0\r\n" +
                "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n" +
                "Accept-Language: en-us,en;q=0.5\r\n" +
                "Accept-Encoding: gzip,deflate\r\n" +
                "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n" +
                "Keep-Alive: 300\r\n" +
                "Connection: keep-alive\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            assertNotNil(request.url)
            assertEqual(request.url, "0.0.0.0:5000/favicon.ico")
            assertEqual(request.url.path, "/favicon.ico")
            assertEqual(request.version, .oneOne)
            assertEqual(request.host, URL.Host(address: "0.0.0.0", port: 5000))
            assertEqual(request.userAgent, "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0")
            assertEqual(request.accept, [
                Request.Accept(.text(.html), priority: 1.0),
                Request.Accept(.application(.xhtml), priority: 1.0),
                Request.Accept(.application(.xml), priority: 0.9),
                Request.Accept(.any, priority: 0.8)]
            )
            assertEqual(request.acceptLanguage, [
                Request.AcceptLanguage(.enUS, priority: 1.0),
                Request.AcceptLanguage(.en, priority: 0.5)]
            )
            assertNotNil(request.acceptEncoding)
            assertEqual(request.acceptEncoding, [.gzip, .deflate])
            assertEqual(request.acceptCharset, [
                Request.AcceptCharset(.isoLatin1),
                Request.AcceptCharset(.utf8, priority: 0.7),
                Request.AcceptCharset(.any, priority: 0.7)]
            )
            assertEqual(request.keepAlive, 300)
            assertEqual(request.connection, .keepAlive)
        }
    }

    func testChankedAllYourBase() {
        scope {
            let stream = InputByteStream(
                "POST /post_chunked_all_your_base HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "1e\r\nall your base are belong to us\r\n" +
                "0\r\n" +
                "\r\n")
            let request = try Request(from: stream)
            assertEqual(request.transferEncoding, [.chunked])
            assertEqual(request.string, "all your base are belong to us")
        }
    }
}
