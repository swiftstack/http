import Test
@testable import HTTP

class URLTests: TestCase {
    func testPath() {
        let url = try! URL("/test")
        assertEqual(url.path, "/test")
    }

    func testQuery() {
        let url = try! URL("/test?query=true")
        assertEqual(url.query, ["query" : "true"])
    }

    func testHost() {
        let url = try! URL("http://domain.com/test")
        assertEqual(url.host, "domain.com")
    }

    func testPort() {
        let url = try! URL("http://domain.com:8080/test")
        assertEqual(url.port, 8080)
    }

    func testScheme() {
        assertEqual(try! URL("http://domain.com/").scheme, .http)
        assertEqual(try! URL("https://domain.com/").scheme, .https)
    }

    func testFragment() {
        let url = try! URL("http://domain.com/#fragment")
        assertEqual(url.fragment, "fragment")
    }

    func testAbsoluteString() {
        let url = try! URL("http://domain.com:8080/test")
        assertEqual(url.absoluteString, "http://domain.com:8080/test")
    }

    func testDescription() {
        let urlString = "http://domain.com:8080/test?query=true#fragment"
        let url = try! URL(urlString)
        assertEqual(url.description, urlString)
    }
}
