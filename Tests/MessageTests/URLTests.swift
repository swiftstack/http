import Test
@testable import HTTP

class URLTests: TestCase {
    func testPath() {
        scope {
            assertEqual(try URL(String("/test")).path, "/test")
            assertEqual(try URL(String("domain.com")).path, "/")
            assertEqual(try URL(String("domain.com/test")).path, "/test")
            assertEqual(try URL(String("domain.com/test/")).path, "/test")
            assertEqual(try URL(String("domain.com/test/#test")).path, "/test")
        }
    }

    func testQuery() {
        scope {
            let url = try URL(String("/test?query=true"))
            assertEqual(url.query, ["query" : "true"])
        }
    }

    func testHost() {
        scope {
            let host = URL.Host(address: "domain.com", port: nil)
            assertEqual(try URL(String("http://domain.com")).host, host)
            assertEqual(try URL(String("domain.com")).host, host)

            let hostWithPort = URL.Host(address: "domain.com", port: 8080)
            assertEqual(
                try URL(String("http://domain.com:8080")).host, hostWithPort)
            assertEqual(
                try URL(String("http://domain.com:8080/")).host, hostWithPort)
        }
    }

    func testScheme() {
        scope {
            assertEqual(try URL(String("http://domain.com/")).scheme, .http)
            assertEqual(try URL(String("https://domain.com/")).scheme, .https)
        }
    }

    func testFragment() {
        scope {
            let url1 = try URL(String("http://domain.com/#fragment"))
            assertEqual(url1.fragment, "fragment")
            let url2 = try URL(String("http://domain.com/test/#fragment"))
            assertEqual(url2.fragment, "fragment")
        }
    }

    func testAbsoluteString() {
        scope {
            let urlString = "http://domain.com:8080/test?query=true#fragment"
            let url = try URL(urlString)
            assertEqual(url.absoluteString, urlString)
        }
    }

    func testDescription() {
        scope {
            let urlString = "http://domain.com:8080/test?query=true#fragment"
            let url = try URL(urlString)
            assertEqual(url.description, urlString)
        }
    }

    func testURLEncoded() {
        scope {
            let urlString =
                "/%D0%BF%D1%80%D0%B8%D0%B2%D0%B5%D1%82-%D0%BC%D0%B8%D1%80?" +
                "%D0%BA%D0%BB%D1%8E%D1%87=" +
                "%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5&" +
                "%D0%BA%D0%BB%D1%8E%D1%872=" +
                "%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B52"

            let url = try URL(urlString)
            assertEqual(url.path, "/привет-мир")
            assertEqual(url.query?.values, [
                "ключ" : "значение",
                "ключ2" : "значение2"])
        }
    }

    func testUnicode() {
        scope {
            let urlString = "http://domain.com:8080/тест?ключ=значение"
            let url = try URL(urlString)
            assertEqual(url.description, urlString)
        }
    }

    func testInvalidScheme() {
        assertThrowsError(try URL(String("htt://"))) { error in
            assertEqual(error as? URL.Error, .invalidScheme)
        }
    }
}
