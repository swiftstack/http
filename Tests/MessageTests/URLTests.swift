import Test
@testable import HTTP

class URLTests: TestCase {
    func testPath() {
        assertEqual(try! URL("/test").path, "/test")
        assertEqual(try! URL("domain.com").path, "/")
        assertEqual(try! URL("domain.com/test").path, "/test")
        assertEqual(try! URL("domain.com/test/").path, "/test")
        assertEqual(try! URL("domain.com/test/#fragment").path, "/test")
    }

    func testQuery() {
        let url = try! URL("/test?query=true")
        assertEqual(url.query, ["query" : "true"])
    }

    func testHost() {
        let host = URL.Host(address: "domain.com", port: nil)
        assertEqual(try! URL("http://domain.com").host, host)
        assertEqual(try! URL("domain.com").host, host)

        let hostWithPort = URL.Host(address: "domain.com", port: 8080)
        assertEqual(try! URL("http://domain.com:8080").host, hostWithPort)
        assertEqual(try! URL("http://domain.com:8080/").host, hostWithPort)
    }

    func testScheme() {
        assertEqual(try! URL("http://domain.com/").scheme, .http)
        assertEqual(try! URL("https://domain.com/").scheme, .https)
    }

    func testFragment() {
        let url1 = try! URL("http://domain.com/#fragment")
        assertEqual(url1.fragment, "fragment")
        let url2 = try! URL("http://domain.com/test/#fragment")
        assertEqual(url2.fragment, "fragment")
    }

    func testAbsoluteString() {
        let urlString = "http://domain.com:8080/test?query=true#fragment"
        let url = try! URL(urlString)
        assertEqual(url.absoluteString, urlString)
    }

    func testDescription() {
        let urlString = "http://domain.com:8080/test?query=true#fragment"
        let url = try! URL(urlString)
        assertEqual(url.description, urlString)
    }

    func testURLEncoded() {
        let urlString =
            "/%D0%BF%D1%80%D0%B8%D0%B2%D0%B5%D1%82-%D0%BC%D0%B8%D1%80?" +
            "%D0%BA%D0%BB%D1%8E%D1%87=" +
            "%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B5&" +
            "%D0%BA%D0%BB%D1%8E%D1%872=" +
            "%D0%B7%D0%BD%D0%B0%D1%87%D0%B5%D0%BD%D0%B8%D0%B52"

        let url = try! URL(urlString)
        assertEqual(url.path, "/привет-мир")
        assertEqual(url.query?.values, ["ключ":"значение", "ключ2":"значение2"])
    }

    func testUnicode() {
        scope {
            let urlString = "http://domain.com:8080/тест?ключ=значение"
            let url = try URL(urlString)
            assertEqual(url.description, urlString)
        }
    }

    func testInvalidScheme() {
        assertThrowsError(try URL("htt://")) { error in
            assertEqual(error as? URL.Error, .invalidScheme)
        }
    }
}
