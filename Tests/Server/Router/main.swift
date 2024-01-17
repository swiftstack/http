import Test

@testable import HTTP

test("MethodsVoid") {
    let router = Router()

    let methodsCollection: [Router.MethodSet] = [
        [.get],
        [.head],
        [.post],
        [.put],
        [.delete],
        [.options]
    ]

    for methods in methodsCollection {
        router.route(path: "/", methods: methods) {
            return Response(status: .ok)
        }
    }

    let requestMethods: [Request.Method] = [
        .get, .head, .post, .put, .delete, .options
    ]

    for method in requestMethods {
        let request = Request(url: "/", method: method)
        let response = await router.handle(request)
        expect(response?.status == .ok)
    }
}

test("AllVoid") {
    let router = Router()

    router.route(path: "/", methods: [.all]) {
        return Response(status: .ok)
    }

    let methods: [Request.Method] = [
        .get, .head, .post, .put, .delete, .options
    ]

    for method in methods {
        guard let handler = router.findHandler(
            path: "/",
            methods: Router.MethodSet(method)
        ) else {
            fail()
            return
        }
        let response = try? await handler(Request(url: "/", method: method))
        expect(response?.status == .ok)
    }
}

test("GetRequest") {
    let router = Router()

    router.route(path: "/", methods: [.get]) { (request: Request) in
        expect(request.url == "/")
        expect(request.method == .get)
        return Response(status: .ok)
    }

    let request = Request(url: "/", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("PostRequest") {
    let router = Router()

    router.route(path: "/", methods: [.post]) { (request: Request) in
        expect(request.url == "/")
        expect(request.method == .post)
        return Response(status: .ok)
    }

    let request = Request(url: "/", method: .post)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("GetURLMatch") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }

    router.route(path: "/:name/:number", methods: [.get]) { (page: Page) in
        expect(page.name == "news")
        expect(page.number == 2)
        return Response(status: .ok)
    }

    let request = Request(url: "/news/2", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("PostURLMatch") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }

    router.route(path: "/:name/:number", methods: [.post]) { (page: Page) in
        expect(page.name == "news")
        expect(page.number == 2)
        return Response(status: .ok)
    }

    let request = Request(url: "/news/2", method: .post)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("GetModel") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }

    router.route(path: "/", methods: [.get]) { (page: Page) in
        expect(page.name == "news")
        expect(page.number == 2)
        return Response(status: .ok)
    }

    let request = Request(url: "/?name=news&number=2", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("PostModel") {
    let router = Router()

    struct Page: Codable {
        let name: String
        let number: Int
    }

    router.route(path: "/", methods: [.post]) { (page: Page) in
        expect(page.name == "news")
        expect(page.number == 2)
        return Response(status: .ok)
    }

    let model = Page(name: "news", number: 2)

    let request = try Request(
        url: "/",
        method: .post,
        body: model)
    let response = await router.handle(request)
    expect(response?.status == .ok)

    let urlEncodedRequest = try Request(
        url: "/",
        method: .post,
        body: model,
        contentType: .formURLEncoded)
    let urlEncodedResponse = await router.handle(urlEncodedRequest)
    expect(urlEncodedResponse?.status == .ok)
}

test("GetURLMatchModel") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }
    struct Params: Decodable {
        let id: Int
        let token: String
    }

    router.route(path: "/:name/:number", methods: [.get])
    { (page: Page, params: Params) in
        expect(page.name == "news")
        expect(page.number == 2)
        expect(params.id == 1)
        expect(params.token == "abcdef")
        return Response(status: .ok)
    }

    let request = Request(url: "/news/2?id=1&token=abcdef", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("PostURLMatchModel") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }
    struct Params: Codable {
        let id: Int
        let token: String
    }

    router.route(path: "/:name/:number", methods: [.post])
    { (page: Page, params: Params) in
        expect(page.name == "news")
        expect(page.number == 2)
        expect(params.id == 1)
        expect(params.token == "abcdef")
        return Response(status: .ok)
    }

    let model = Params(id: 1, token: "abcdef")
    let request = try Request(
        url: "/news/2",
        method: .post,
        body: model)
    let response = await router.handle(request)
    expect(response?.status == .ok)

    let formURLEncodedRequest = try Request(
        url: "/news/2",
        method: .post,
        body: model,
        contentType: .formURLEncoded)
    let formResponse = await router.handle(formURLEncodedRequest)
    expect(formResponse?.status == .ok)
}

test("GetRequestURLMatch") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }

    router.route(path: "/:name/:number", methods: [.get])
    { (request: Request, page: Page) in
        expect(request.url == "/news/2")
        expect(request.method == .get)
        expect(page.name == "news")
        expect(page.number == 2)
        return Response(status: .ok)
    }

    let request = Request(url: "/news/2", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("PostRequestURLMatch") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }

    router.route(path: "/:name/:number", methods: [.post])
    { (request: Request, page: Page) in
        expect(request.url == "/news/2")
        expect(request.method == .post)
        expect(page.name == "news")
        expect(page.number == 2)
        return Response(status: .ok)
    }

    let request = Request(url: "/news/2", method: .post)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("GetRequestModel") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }

    router.route(path: "/", methods: [.get])
    { (request: Request, page: Page) in
        expect(request.url == "/?name=news&number=2")
        expect(request.url.path == "/")
        expect(request.method == .get)
        expect(page.name == "news")
        expect(page.number == 2)
        return Response(status: .ok)
    }

    let request = Request(url: "/?name=news&number=2", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("PostRequestModel") {
    let router = Router()

    struct Page: Codable {
        let name: String
        let number: Int
    }

    router.route(path: "/", methods: [.post])
    { (request: Request, page: Page) in
        expect(request.url == "/")
        expect(request.method == .post)
        expect(page.name == "news")
        expect(page.number == 2)
        return Response(status: .ok)
    }

    let model = Page(name: "news", number: 2)
    let request = try Request(
        url: "/",
        method: .post,
        body: model)
    let response = await router.handle(request)
    expect(response?.status == .ok)

    let formURLEncodedRequest = try Request(
        url: "/",
        method: .post,
        body: model,
        contentType: .formURLEncoded)
    let formResponse = await router.handle(formURLEncodedRequest)
    expect(formResponse?.status == .ok)
}

test("GetRequestURLMatchModel") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }

    struct Params: Decodable {
        let id: Int
        let token: String
    }

    router.route(path: "/:name/:number", methods: [.get])
    { (request: Request, page: Page, params: Params) in
        expect(request.url == "/news/2?id=1&token=abcdef")
        expect(request.url.path == "/news/2")
        expect(request.method == .get)
        expect(page.name == "news")
        expect(page.number == 2)
        expect(params.id == 1)
        expect(params.token == "abcdef")
        return Response(status: .ok)
    }

    let request = Request(url: "/news/2?id=1&token=abcdef", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

test("PostRequestURLMatchModel") {
    let router = Router()

    struct Page: Decodable {
        let name: String
        let number: Int
    }

    struct Params: Codable {
        let id: Int
        let token: String
    }

    router.route(path: "/:name/:number", methods: [.post])
    { (request: Request, page: Page, params: Params) in
        expect(request.url == "/news/2")
        expect(request.method == .post)
        expect(page.name == "news")
        expect(page.number == 2)
        expect(params.id == 1)
        expect(params.token == "abcdef")
        return Response(status: .ok)
    }

    let model = Params(id: 1, token: "abcdef")
    let request = try Request(
        url: "/news/2",
        method: .post,
        body: model)
    let response = await router.handle(request)
    expect(response?.status == .ok)

    let formURLEncodedRequest = try Request(
        url: "/news/2",
        method: .post,
        body: model,
        contentType: .formURLEncoded)
    let formResponse = await router.handle(formURLEncodedRequest)
    expect(formResponse?.status == .ok)
}

test("UnicodeRoute") {
    let router = Router()

    router.route(path: "/новости", methods: [.get]) { (request: Request) in
        expect(request.url == "/новости")
        expect(request.method == .get)
        return Response(status: .ok)
    }

    let request = Request(url: "/новости", method: .get)
    let response = await router.handle(request)
    expect(response?.status == .ok)
}

await run()
