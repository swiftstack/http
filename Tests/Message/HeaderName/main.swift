import Test

@testable import HTTP

test("HeaderName") {
    let name = HeaderName("Content-Length")
    expect(name == HeaderName("Content-Length"))
    expect(name == HeaderName("content-length"))
}

test("HeaderNameDescription") {
    let name = HeaderName("Content-Length")
    expect(name.description == "Content-Length")
}

await run()
