import Test

@testable import HTTP

test("Request") {
    let request = Request(url: "/", method: .get)
    expect(request.method == .get)
    expect(request.url.path == "/")
}

test("DefaultRequest") {
    let request = Request()
    expect(request.method == .get)
    expect(request.url.path == "/")
}

test("DefaultMethod") {
    let request = Request(url: "/")
    expect(request.method == .get)
    expect(request.url.path == "/")
}

test("DefaultURL") {
    let request = Request(method: .get)
    expect(request.method == .get)
    expect(request.url.path == "/")
}

test("FromString") {
    let request = Request(url: "/test?query=true")
    expect(request.url.path == "/test")
    expect(request.url.query == ["query": "true"])
}

await run()
