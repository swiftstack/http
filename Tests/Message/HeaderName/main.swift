import Test

@testable import HTTP

test.case("HeaderName") {
    let name = HeaderName("Content-Length")
    expect(name == HeaderName("Content-Length"))
    expect(name == HeaderName("content-length"))
}

test.case("HeaderNameDescription") {
    let name = HeaderName("Content-Length")
    expect(name.description == "Content-Length")
}

await test.run()
