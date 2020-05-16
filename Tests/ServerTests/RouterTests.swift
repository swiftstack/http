import Test

@testable import HTTP

class RouterTests: TestCase {
    func testMethodsVoid() {
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
            let response = router.handleRequest(request)
            expect(response?.status == .ok)
        }
    }

    func testAllVoid() {
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
            let response = try? handler(Request(url: "/", method: method))
            expect(response?.status == .ok)
        }
    }

    func testGetRequest() {
        let router = Router()

        router.route(path: "/", methods: [.get]) { (request: Request) in
            expect(request.url == "/")
            expect(request.method == .get)
            return Response(status: .ok)
        }

        let request = Request(url: "/", method: .get)
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testPostRequest() {
        let router = Router()

        router.route(path: "/", methods: [.post]) { (request: Request) in
            expect(request.url == "/")
            expect(request.method == .post)
            return Response(status: .ok)
        }

        let request = Request(url: "/", method: .post)
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testGetURLMatch() {
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
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testPostURLMatch() {
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
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testGetModel() {
        let router = Router()

        struct Page: Decodable {
            let name: String
            let number: Int
        }

        router.route(path: "/", methods: [.get])
        { (page: Page) in
            expect(page.name == "news")
            expect(page.number == 2)
            return Response(status: .ok)
        }

        let request = Request(url: "/?name=news&number=2", method: .get)
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testPostModel() {
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

        scope {
            let model = Page(name: "news", number: 2)

            let request = try Request(
                url: "/",
                method: .post,
                body: model)
            let response = router.handleRequest(request)
            expect(response?.status == .ok)

            let formURLEncodedRequest = try Request(
                url: "/",
                method: .post,
                body: model,
                contentType: .formURLEncoded)
            let formURLEncodedResponse = router.handleRequest(formURLEncodedRequest)
            expect(formURLEncodedResponse?.status == .ok)
        }
    }

    func testGetURLMatchModel() {
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
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testPostURLMatchModel() {
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

        scope {
            let model = Params(id: 1, token: "abcdef")
            let request = try Request(
                url: "/news/2",
                method: .post,
                body: model)
            let response = router.handleRequest(request)
            expect(response?.status == .ok)

            let formURLEncodedRequest = try Request(
                url: "/news/2",
                method: .post,
                body: model,
                contentType: .formURLEncoded)
            let formResponse = router.handleRequest(formURLEncodedRequest)
            expect(formResponse?.status == .ok)
        }
    }

    func testGetRequestURLMatch() {
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
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testPostRequestURLMatch() {
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
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testGetRequestModel() {
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
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testPostRequestModel() {
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

        scope {
            let model = Page(name: "news", number: 2)
            let request = try Request(
                url: "/",
                method: .post,
                body: model)
            let response = router.handleRequest(request)
            expect(response?.status == .ok)

            let formURLEncodedRequest = try Request(
                url: "/",
                method: .post,
                body: model,
                contentType: .formURLEncoded)
            let formResponse = router.handleRequest(formURLEncodedRequest)
            expect(formResponse?.status == .ok)
        }
    }

    func testGetRequestURLMatchModel() {
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
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }

    func testPostRequestURLMatchModel() {
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

        scope {
            let model = Params(id: 1, token: "abcdef")
            let request = try Request(
                url: "/news/2",
                method: .post,
                body: model)
            let response = router.handleRequest(request)
            expect(response?.status == .ok)

            let formURLEncodedRequest = try Request(
                url: "/news/2",
                method: .post,
                body: model,
                contentType: .formURLEncoded)
            let formResponse = router.handleRequest(formURLEncodedRequest)
            expect(formResponse?.status == .ok)
        }
    }

    func testUnicodeRoute() {
        let router = Router()

        router.route(path: "/новости", methods: [.get]) { (request: Request) in
            expect(request.url == "/новости")
            expect(request.method == .get)
            return Response(status: .ok)
        }

        let request = Request(url: "/новости", method: .get)
        let response = router.handleRequest(request)
        expect(response?.status == .ok)
    }
}
