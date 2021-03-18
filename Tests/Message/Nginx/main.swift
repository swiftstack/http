import URL
import Test
import Stream

@testable import HTTP

test.case("CurlGet") {
    let stream = InputByteStream(
        "GET /test HTTP/1.1\r\n" +
        "User-Agent: curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1\r\n" +
        "Host: 0.0.0.0:5000\r\n" +
        "Accept: */*\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.url.path == "/test")
    expect(request.url == "0.0.0.0:5000/test")
    expect(request.version == .oneOne)
    expect(request.userAgent == "curl/7.18.0 (i486-pc-linux-gnu) libcurl/7.18.0 OpenSSL/0.9.8g zlib/1.2.3.3 libidn/1.1")
    expect(request.host == URL.Host(address: "0.0.0.0", port: 5000))
}

test.case("FirefoxGet") {
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
    let request = try await Request.decode(from: stream)
    expect(request.url == "0.0.0.0:5000/favicon.ico")
    expect(request.url.path == "/favicon.ico")
    expect(request.version == .oneOne)
    expect(request.host == URL.Host(address: "0.0.0.0", port: 5000))
    expect(request.userAgent == "Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9) Gecko/2008061015 Firefox/3.0")
    expect(request.accept == [
        Request.Accept(.text(.html), priority: 1.0),
        Request.Accept(.application(.xhtml), priority: 1.0),
        Request.Accept(.application(.xml), priority: 0.9),
        Request.Accept(.any, priority: 0.8)]
    )
    expect(request.acceptLanguage == [
        Request.AcceptLanguage(.enUS, priority: 1.0),
        Request.AcceptLanguage(.en, priority: 0.5)]
    )
    expect(request.acceptEncoding != nil)
    expect(request.acceptEncoding == [.gzip, .deflate])
    expect(request.acceptCharset == [
        Request.AcceptCharset(.isoLatin1),
        Request.AcceptCharset(.utf8, priority: 0.7),
        Request.AcceptCharset(.any, priority: 0.7)]
    )
    expect(request.keepAlive == 300)
    expect(request.connection == .keepAlive)
}

test.case("ChankedAllYourBase") {
    let stream = InputByteStream(
        "POST /post_chunked_all_your_base HTTP/1.1\r\n" +
        "Transfer-Encoding: chunked\r\n" +
        "\r\n" +
        "1e\r\nall your base are belong to us\r\n" +
        "0\r\n" +
        "\r\n")
    let request = try await Request.decode(from: stream)
    expect(request.transferEncoding == [.chunked])
    let body = try await request.readBody()
    expect(body == ASCII("all your base are belong to us"))
}

test.run()
