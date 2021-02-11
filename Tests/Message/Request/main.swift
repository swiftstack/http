import Test

@testable import HTTP

test.case("Request") {
    let request = Request(url: "/", method: .get)
    expect(request.method == .get)
    expect(request.url.path == "/")
}

test.case("DefaultRequest") {
    let request = Request()
    expect(request.method == .get)
    expect(request.url.path == "/")
}

test.case("DefaultMethod") {
    let request = Request(url: "/")
    expect(request.method == .get)
    expect(request.url.path == "/")
}

test.case("DefaultURL") {
    let request = Request(method: .get)
    expect(request.method == .get)
    expect(request.url.path == "/")
}

test.case("FromString") {
    let request = Request(url: "/test?query=true")
    expect(request.url.path == "/test")
    expect(request.url.query == ["query" : "true"])
}

test.run()
