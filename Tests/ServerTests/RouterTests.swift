import Test

@testable import HTTP

extension Router {
    func handleRequest(_ request: Request) -> Response? {
        guard let handler = findHandler(
            path: request.url.path,
            methods: Router.MethodSet(request.method))
        else {
            return nil
        }
        return try? handler(request)
    }
}

class RouterTests: TestCase {
    func testMethodsVoid() {
        var router = Router()

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
            let request = Request(method: method, url: "/")
            let response = router.handleRequest(request)
            assertEqual(response?.status, .ok)
        }
    }

    func testAllVoid() {
        var router = Router()

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
            let response = try? handler(Request(method: method, url: "/"))
            assertEqual(response?.status, .ok)
        }
    }

    func testGetRequest() {
        var router = Router()

        router.route(path: "/", methods: [.get]) { (request: Request) in
            assertEqual(request.url, "/")
            assertEqual(request.method, .get)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testPostRequest() {
        var router = Router()

        router.route(path: "/", methods: [.post]) { (request: Request) in
            assertEqual(request.url, "/")
            assertEqual(request.method, .post)
            return Response(status: .ok)
        }

        let request = Request(method: .post, url: "/")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testGetURLMatch() {
        var router = Router()

        struct Page: Decodable {
            let name: String
            let number: Int
        }

        router.route(path: "/:name/:number", methods: [.get]) { (page: Page) in
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/news/2")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testPostURLMatch() {
        var router = Router()

        struct Page: Decodable {
            let name: String
            let number: Int
        }

        router.route(path: "/:name/:number", methods: [.post]) { (page: Page) in
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .post, url: "/news/2")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testGetModel() {
        var router = Router()

        struct Page: Decodable {
            let name: String
            let number: Int
        }

        router.route(path: "/", methods: [.get])
        { (page: Page) in
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/?name=news&number=2")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testPostModel() {
        var router = Router()

        struct Page: Codable {
            let name: String
            let number: Int
        }

        router.route(path: "/", methods: [.post]) { (page: Page) in
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        do {
            let model = Page(name: "news", number: 2)

            let request = try Request(
                method: .post,
                url: "/",
                body: model)
            let response = router.handleRequest(request)
            assertEqual(response?.status, .ok)

            let formURLEncodedRequest = try Request(
                method: .post,
                url: "/",
                body: model,
                contentType: .formURLEncoded)
            let formURLEncodedResponse = router.handleRequest(formURLEncodedRequest)
            assertEqual(formURLEncodedResponse?.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testGetURLMatchModel() {
        var router = Router()

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
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            assertEqual(params.id, 1)
            assertEqual(params.token, "abcdef")
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/news/2?id=1&token=abcdef")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testPostURLMatchModel() {
        var router = Router()

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
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            assertEqual(params.id, 1)
            assertEqual(params.token, "abcdef")
            return Response(status: .ok)
        }

        do {
            let model = Params(id: 1, token: "abcdef")
            let request = try Request(
                method: .post,
                url: "/news/2",
                body: model)
            let response = router.handleRequest(request)
            assertEqual(response?.status, .ok)

            let formURLEncodedRequest = try Request(
                method: .post,
                url: "/news/2",
                body: model,
                contentType: .formURLEncoded)
            let formResponse = router.handleRequest(formURLEncodedRequest)
            assertEqual(formResponse?.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testGetRequestURLMatch() {
        var router = Router()

        struct Page: Decodable {
            let name: String
            let number: Int
        }

        router.route(path: "/:name/:number", methods: [.get])
        { (request: Request, page: Page) in
            assertEqual(request.url, "/news/2")
            assertEqual(request.method, .get)
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/news/2")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testPostRequestURLMatch() {
        var router = Router()

        struct Page: Decodable {
            let name: String
            let number: Int
        }

        router.route(path: "/:name/:number", methods: [.post])
        { (request: Request, page: Page) in
            assertEqual(request.url, "/news/2")
            assertEqual(request.method, .post)
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .post, url: "/news/2")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testGetRequestModel() {
        var router = Router()

        struct Page: Decodable {
            let name: String
            let number: Int
        }

        router.route(path: "/", methods: [.get])
        { (request: Request, page: Page) in
            assertEqual(request.url, "/?name=news&number=2")
            assertEqual(request.url.path, "/")
            assertEqual(request.method, .get)
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/?name=news&number=2")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testPostRequestModel() {
        var router = Router()

        struct Page: Codable {
            let name: String
            let number: Int
        }

        router.route(path: "/", methods: [.post])
        { (request: Request, page: Page) in
            assertEqual(request.url, "/")
            assertEqual(request.method, .post)
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        do {
            let model = Page(name: "news", number: 2)
            let request = try Request(
                method: .post,
                url: "/",
                body: model)
            let response = router.handleRequest(request)
            assertEqual(response?.status, .ok)

            let formURLEncodedRequest = try Request(
                method: .post,
                url: "/",
                body: model,
                contentType: .formURLEncoded)
            let formResponse = router.handleRequest(formURLEncodedRequest)
            assertEqual(formResponse?.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testGetRequestURLMatchModel() {
        var router = Router()

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
            assertEqual(request.url, "/news/2?id=1&token=abcdef")
            assertEqual(request.url.path, "/news/2")
            assertEqual(request.method, .get)
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            assertEqual(params.id, 1)
            assertEqual(params.token, "abcdef")
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/news/2?id=1&token=abcdef")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }

    func testPostRequestURLMatchModel() {
        var router = Router()

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
            assertEqual(request.url, "/news/2")
            assertEqual(request.method, .post)
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            assertEqual(params.id, 1)
            assertEqual(params.token, "abcdef")
            return Response(status: .ok)
        }

        do {
            let model = Params(id: 1, token: "abcdef")
            let request = try Request(
                method: .post,
                url: "/news/2",
                body: model)
            let response = router.handleRequest(request)
            assertEqual(response?.status, .ok)

            let formURLEncodedRequest = try Request(
                method: .post,
                url: "/news/2",
                body: model,
                contentType: .formURLEncoded)
            let formResponse = router.handleRequest(formURLEncodedRequest)
            assertEqual(formResponse?.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testUnicodeRoute() {
        var router = Router()

        router.route(path: "/новости", methods: [.get]) { (request: Request) in
            assertEqual(request.url, "/новости")
            assertEqual(request.method, .get)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/новости")
        let response = router.handleRequest(request)
        assertEqual(response?.status, .ok)
    }
}
