import Log
import Test

@testable import HTTP

test("InternalServerError") {
    Log.isEnabled = false

    let router = Router(middleware: [ErrorHandlerMiddleware.self])

    struct Error: Swift.Error {}

    router.route(get: "/") {
        throw Error()
    }

    let request = Request(url: "/", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .internalServerError)
}

test("NotFound") {
    Log.isEnabled = false

    let router = Router(middleware: [ErrorHandlerMiddleware.self])

    router.route(get: "/") {
        throw Server.Error.notFound
    }

    let request = Request(url: "/", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .notFound)
}

await run()
