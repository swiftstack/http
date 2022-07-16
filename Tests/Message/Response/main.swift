import Test

@testable import HTTP

test.case("Response") {
    let response = Response(status: .ok)
    expect(response.status == .ok)
    expect(response.contentType == nil)
}

test.case("DefaultStatus") {
    let response = Response()
    expect(response.status == .ok)
    expect(response.contentType == nil)
}

test.case("ContentType") {
    let response = Response(status: .ok, bytes: [], contentType: .json)
    expect(response.contentType == .json)
}

test.case("Bytes") {
    _ = Response(status: .ok, bytes: [], contentType: .stream)
    _ = Response(bytes: [], contentType: .stream)
    _ = Response(bytes: [])
}

test.case("String") {
    _ = Response(status: .ok, string: "", contentType: .text)
    _ = Response(string: "", contentType: .text)
    _ = Response(string: "")
}

test.case("XML") {
    _ = Response(status: .ok, xml: "")
    _ = Response(xml: "")
}

test.case("HTML") {
    _ = Response(status: .ok, html: "")
    _ = Response(html: "")
}

test.case("JavaScript") {
    _ = Response(status: .ok, javascript: "")
    _ = Response(javascript: "")
}

await test.run()
