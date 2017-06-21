import Test
@testable import Server

class RouterTests: TestCase {
    func testGetVoid() {
        var router = Router()

        router.route(methods: [.get], url: "/") {
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testPostVoid() {
        var router = Router()

        router.route(methods: [.post], url: "/") {
            return Response(status: .ok)
        }

        let request = Request(method: .post, url: "/")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testAllVoid() {
        var router = Router()

        router.route(methods: [.all], url: "/") {
            return Response(status: .ok)
        }

        let get = router.handleRequest(Request(method: .get, url: "/"))
        let head = router.handleRequest(Request(method: .head, url: "/"))
        let post = router.handleRequest(Request(method: .post, url: "/"))
        let put = router.handleRequest(Request(method: .put, url: "/"))
        let delete = router.handleRequest(Request(method: .delete, url: "/"))
        let options = router.handleRequest(Request(method: .options, url: "/"))

        assertEqual(get.status, .ok)
        assertEqual(head.status, .ok)
        assertEqual(post.status, .ok)
        assertEqual(put.status, .ok)
        assertEqual(delete.status, .ok)
        assertEqual(options.status, .ok)
    }

    func testGetRequest() {
        var router = Router()

        router.route(methods: [.get], url: "/") { (request: Request) in
            assertEqual(request.url, "/")
            assertEqual(request.method, .get)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testPostRequest() {
        var router = Router()

        router.route(methods: [.post], url: "/") { (request: Request) in
            assertEqual(request.url, "/")
            assertEqual(request.method, .post)
            return Response(status: .ok)
        }

        let request = Request(method: .post, url: "/")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testGetURLMatch() {
        var router = Router()

        struct Page: URLDecodable {
            let name: String
            let number: Int
        }

        router.route(methods: [.get], url: "/:name/:number") { (page: Page) in
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/news/2")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testPostURLMatch() {
        var router = Router()

        struct Page: URLDecodable {
            let name: String
            let number: Int
        }

        router.route(methods: [.post], url: "/:name/:number") { (page: Page) in
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .post, url: "/news/2")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testGetModel() {
        var router = Router()

        struct Page: Decodable {
            let name: String
            let number: Int
        }

        router.route(methods: [.get], url: "/")
        { (page: Page) in
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/?name=news&number=2")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testPostModel() {
        var router = Router()

        struct Page: Codable {
            let name: String
            let number: Int
        }

        router.route(methods: [.post], url: "/") { (page: Page) in
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        do {
            let model = Page(name: "news", number: 2)
            let request = try Request(method: .post, url: "/", json: model)
            let response = router.handleRequest(request)
            assertEqual(response.status, .ok)

            let urlEncodedRequest = try Request(
                method: .post, url: "/", urlEncoded: model)
            let urlEncodedResponse = router.handleRequest(urlEncodedRequest)
            assertEqual(urlEncodedResponse.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testGetURLMatchModel() {
        var router = Router()

        struct Page: URLDecodable {
            let name: String
            let number: Int
        }
        struct Params: Decodable {
            let id: Int
            let token: String
        }

        router.route(methods: [.get], url: "/:name/:number")
        { (page: Page, params: Params) in
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            assertEqual(params.id, 1)
            assertEqual(params.token, "abcdef")
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/news/2?id=1&token=abcdef")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testPostURLMatchModel() {
        var router = Router()

        struct Page: URLDecodable {
            let name: String
            let number: Int
        }
        struct Params: Codable {
            let id: Int
            let token: String
        }

        router.route(methods: [.post], url: "/:name/:number")
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
                method: .post, url: "/news/2", json: model)
            let response = router.handleRequest(request)
            assertEqual(response.status, .ok)

            let urlEncodedRequest = try Request(
                method: .post, url: "/news/2", urlEncoded: model)
            let urlEncodedResponse = router.handleRequest(urlEncodedRequest)
            assertEqual(urlEncodedResponse.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testGetRequestURLMatch() {
        var router = Router()

        struct Page: URLDecodable {
            let name: String
            let number: Int
        }

        router.route(methods: [.get], url: "/:name/:number")
        { (request: Request, page: Page) in
            assertEqual(request.url, "/news/2")
            assertEqual(request.method, .get)
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .get, url: "/news/2")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testPostRequestURLMatch() {
        var router = Router()

        struct Page: URLDecodable {
            let name: String
            let number: Int
        }

        router.route(methods: [.post], url: "/:name/:number")
        { (request: Request, page: Page) in
            assertEqual(request.url, "/news/2")
            assertEqual(request.method, .post)
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        let request = Request(method: .post, url: "/news/2")
        let response = router.handleRequest(request)
        assertEqual(response.status, .ok)
    }

    func testGetRequestModel() {
        var router = Router()

        struct Page: Decodable {
            let name: String
            let number: Int
        }

        router.route(methods: [.get], url: "/")
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
        assertEqual(response.status, .ok)
    }

    func testPostRequestModel() {
        var router = Router()

        struct Page: Codable {
            let name: String
            let number: Int
        }

        router.route(methods: [.post], url: "/")
        { (request: Request, page: Page) in
            assertEqual(request.url, "/")
            assertEqual(request.method, .post)
            assertEqual(page.name, "news")
            assertEqual(page.number, 2)
            return Response(status: .ok)
        }

        do {
            let model = Page(name: "news", number: 2)
            let request = try Request(method: .post, url: "/", json: model)
            let response = router.handleRequest(request)
            assertEqual(response.status, .ok)

            let urlEncodedRequest = try Request(
                method: .post, url: "/", urlEncoded: model)
            let urlEncodedResponse = router.handleRequest(urlEncodedRequest)
            assertEqual(urlEncodedResponse.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }

    func testGetRequestURLMatchModel() {
        var router = Router()

        struct Page: URLDecodable {
            let name: String
            let number: Int
        }

        struct Params: Decodable {
            let id: Int
            let token: String
        }

        router.route(methods: [.get], url: "/:name/:number")
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
        assertEqual(response.status, .ok)
    }

    func testPostRequestURLMatchModel() {
        var router = Router()

        struct Page: URLDecodable {
            let name: String
            let number: Int
        }

        struct Params: Codable {
            let id: Int
            let token: String
        }

        router.route(methods: [.post], url: "/:name/:number")
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
                method: .post, url: "/news/2", json: model)
            let response = router.handleRequest(request)
            assertEqual(response.status, .ok)

            let urlEncodedRequest = try Request(
                method: .post, url: "/news/2", urlEncoded: model)
            let urlEncodedResponse = router.handleRequest(urlEncodedRequest)
            assertEqual(urlEncodedResponse.status, .ok)
        } catch {
            fail(String(describing: error))
        }
    }
}
