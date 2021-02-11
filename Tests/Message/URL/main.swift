import Test

@testable import HTTP

test.case("Path") {
    expect(try URL(String("/test")).path == "/test")
    expect(try URL(String("domain.com")).path == "/")
    expect(try URL(String("domain.com/test")).path == "/test")
    expect(try URL(String("domain.com/test/")).path == "/test")
    expect(try URL(String("domain.com/test/#test")).path == "/test")
}

test.case("Query") {
    let url = try URL(String("/test?query=true"))
    expect(url.query == ["query" : "true"])
}

test.case("Host") {
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

test.case("Scheme") {
    expect(try URL(String("http://domain.com/")).scheme == .http)
    expect(try URL(String("https://domain.com/")).scheme == .https)
}

test.case("Fragment") {
    let url1 = try URL(String("http://domain.com/#fragment"))
    expect(url1.fragment == "fragment")
    let url2 = try URL(String("http://domain.com/test/#fragment"))
    expect(url2.fragment == "fragment")
}

test.case("AbsoluteString") {
    let urlString = "http://domain.com:8080/test?query=true#fragment"
    let url = try URL(urlString)
    expect(url.absoluteString == urlString)
}

test.case("Description") {
    let urlString = "http://domain.com:8080/test?query=true#fragment"
    let url = try URL(urlString)
    expect(url.description == urlString)
}

test.case("URLEncoded") {
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

test.case("Unicode") {
    let urlString = "http://domain.com:8080/тест?ключ=значение"
    let url = try URL(urlString)
    expect(url.description == urlString)
}

test.case("InvalidScheme") {
    expect(throws: URL.Error.invalidScheme) {
        try URL(String("htt://"))
    }
}

test.run()
