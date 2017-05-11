@testable import HTTP

class NginxTests: TestCase {
    func testCurlGet() {
        do {
            let bytes = ASCII("GET /test HTTP/1.1\r\n" +
                "User-Agent: curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1\r\n" +
                "Host: 0.0.0.0=5000\r\n" +
                "Accept: */*\r\n" +
                "\r\n")
            let request = try Request(from: bytes)
            assertNotNil(request.url)
            assertEqual(request.url.path, "/test")
            assertEqual(request.url, "/test")
            assertEqual(request.version, .oneOne)
            assertEqual(request.host, "0.0.0.0=5000")
        } catch {
            fail(String(describing: error))
        }
    }

    func testFirefoxGet() {
        do {
            let bytes = ASCII("GET /favicon.ico HTTP/1.1\r\n" +
                "Host: 0.0.0.0=5000\r\n" +
                "User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0\r\n" +
                "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8\r\n" +
                "Accept-Language: en-us,en;q=0.5\r\n" +
                "Accept-Encoding: gzip,deflate\r\n" +
                "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7\r\n" +
                "Keep-Alive: 300\r\n" +
                "Connection: keep-alive\r\n" +
                "\r\n")
            let request = try Request(from: bytes)
            assertNotNil(request.url)
            assertEqual(request.url, "/favicon.ico")
            assertEqual(request.url.path, "/favicon.ico")
            assertEqual(request.version, .oneOne)
            assertEqual(request.host, "0.0.0.0=5000")
            assertEqual(request.userAgent, "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0")
            assertEqual(request.accept, "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
            assertEqual(request.acceptLanguage, "en-us,en;q=0.5")
            assertNotNil(request.acceptEncoding)
            assertEqual(request.acceptEncoding ?? [], [.gzip, .deflate])
            assertEqual(request.acceptCharset ?? [], [
                AcceptCharset(.isoLatin1),
                AcceptCharset(.utf8, priority: 0.7),
                AcceptCharset(.any, priority: 0.7)
            ])
            assertEqual(request.keepAlive, 300)
            assertEqual(request.connection, "keep-alive")
        } catch {
            fail(String(describing: error))
        }
    }

    func testChankedAllYourBase() {
        do {
            let bytes = ASCII("POST /post_chunked_all_your_base HTTP/1.1\r\n" +
                "Transfer-Encoding: chunked\r\n" +
                "\r\n" +
                "1e\r\nall your base are belong to us\r\n" +
                "0\r\n" +
                "\r\n")
            let request = try Request(from: bytes)
            assertEqual(request.transferEncoding, "chunked")
            assertEqual(request.body, "all your base are belong to us")
        } catch {
            fail(String(describing: error))
        }
    }
}
