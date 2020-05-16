import Test
@testable import HTTP

class URLTests: TestCase {
    func testPath() {
        scope {
            expect(try URL(String("/test")).path == "/test")
            expect(try URL(String("domain.com")).path == "/")
            expect(try URL(String("domain.com/test")).path == "/test")
            expect(try URL(String("domain.com/test/")).path == "/test")
            expect(try URL(String("domain.com/test/#test")).path == "/test")
        }
    }

    func testQuery() {
        scope {
            let url = try URL(String("/test?query=true"))
            expect(url.query == ["query" : "true"])
        }
    }

    func testHost() {
        scope {
            let host = URL.Host(address: "domain.com", port: nil)
            expect(try URL(String("http://domain.com")).host == host)
            expect(try URL(String("domain.com")).host == host)

            let hostWithPort = URL.Host(address: "domain.com", port: 8080)

            expect(
                try URL(String("http://domain.com:8080")).host
                ==
                hostWithPort)

            expect(
                try URL(String("http://domain.com:8080/")).host
                ==
                 hostWithPort)
        }
    }

    func testScheme() {
        scope {
            expect(try URL(String("http://domain.com/")).scheme == .http)
            expect(try URL(String("https://domain.com/")).scheme == .https)
        }
    }

    func testFragment() {
        scope {
            let url1 = try URL(String("http://domain.com/#fragment"))
            expect(url1.fragment == "fragment")
            let url2 = try URL(String("http://domain.com/test/#fragment"))
            expect(url2.fragment == "fragment")
        }
    }

    func testAbsoluteString() {
        scope {
            let urlString = "http://domain.com:8080/test?query=true#fragment"
            let url = try URL(urlString)
            expect(url.absoluteString == urlString)
        }
    }

    func testDescription() {
        scope {
            let urlString = "http://domain.com:8080/test?query=true#fragment"
            let url = try URL(urlString)
            expect(url.description == urlString)
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
            expect(url.path == "/привет-мир")
            expect(url.query?.values == [
                "ключ" : "значение",
                "ключ2" : "значение2"])
        }
    }

    func testUnicode() {
        scope {
            let urlString = "http://domain.com:8080/тест?ключ=значение"
            let url = try URL(urlString)
            expect(url.description == urlString)
        }
    }

    func testInvalidScheme() {
        expect(throws: URL.Error.invalidScheme) {
            try URL(String("htt://"))
        }
    }
}
