import Test

@testable import HTTP

extension String: Swift.Error {}

func makeMistake() throws {
    throw "expected failure"
}

test.case("InternalServerError") {
    let router = Router(middleware: [ErrorHandlerMiddleware.self])

    router.route(get: "/") {
        try makeMistake()
        return Response(status: .ok)
    }

    let request = Request(url: "/", method: .get)
    let response = await router.handleRequest(request)
    expect(response?.status == .internalServerError)
}

test.case("NotFound") {
    let router = Router(middleware: [ErrorHandlerMiddleware.self])

    router.route(get: "/") {
        throw Error.notFound
    }

    let request = Request(url: "/", method: .get)
    let response = await router.handleRequest(request)
    expect(response?.status == .notFound)
}

test.run()
