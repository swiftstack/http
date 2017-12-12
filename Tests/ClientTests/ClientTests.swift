import Test
import HTTP
import Network
import Dispatch
import AsyncDispatch
@testable import Client

import struct Foundation.Data

class ClientTests: TestCase {
    override func setUp() {
        AsyncDispatch().registerGlobal()
    }
    
    func testInitializer() {
        let client = Client(host: "127.0.0.1", port: 80)
        assertEqual(client.host, URL.Host(address: "127.0.0.1", port: 80))
    }

    func testURLInitializer() {
        guard let client = Client(url: "http://127.0.0.1") else {
            fail()
            return
        }
        assertEqual(client.host, URL.Host(address: "127.0.0.1", port: nil))
    }

    func testRequest() {
        let semaphore = DispatchSemaphore(value: 0)

        async.task {
            do {
                let expected = "GET / HTTP/1.1\r\n" +
                    "Host: 127.0.0.1:5001\r\n" +
                    "Accept-Encoding: deflate\r\n" +
                    "\r\n"

                let responseBytes = [UInt8]("HTTP/1.1 200 OK\r\n\r\n".utf8)

                let socket = try Socket()
                    .bind(to: "127.0.0.1", port: 5001)
                    .listen()

                semaphore.signal()

                let client = try socket.accept()
                var buffer = [UInt8](repeating: 0, count: 100)
                let count = try client.receive(to: &buffer)
                _ = try client.send(bytes: responseBytes)

                let request = String(ascii: [UInt8](buffer[..<count]))
                assertEqual(request, expected)
            } catch {
                async.loop.terminate()
                fail(String(describing: error))
            }
        }

        semaphore.wait()

        async.task {
            do {
                let request = Request()

                let client = Client(host: "127.0.0.1", port: 5001)
                try client.connect()
                let response = try client.makeRequest(request)

                assertEqual(response.status, .ok)
                assertNil(response.body)

                async.loop.terminate()
            } catch {
                async.loop.terminate()
                fail(String(describing: error))
            }
        }

        async.loop.run()
    }

    func testDeflate() {
        let data = Data(base64Encoded: "80jNycnXUQjPL8pJUQQA")!

        let semaphore = DispatchSemaphore(value: 0)

        async.task {
            do {
                var response = Response(status: .ok)
                response.contentType = ContentType(mediaType: .text(.plain))
                response.contentEncoding = [.deflate]
                response.rawBody = [UInt8](data)

                let socket = try Socket()
                    .bind(to: "127.0.0.1", port: 5002)
                    .listen()

                semaphore.signal()

                let client = try socket.accept()
                var buffer = [UInt8](repeating: 0, count: 100)
                let count = try client.receive(to: &buffer)
                let request = try Request(from: [UInt8](buffer[..<count]))

                assertEqual(request.acceptEncoding ?? [], [.deflate])

                var responseBytes = [UInt8]()
                response.encode(to: &responseBytes)
                _ = try client.send(bytes: responseBytes)

            } catch {
                async.loop.terminate()
                fail(String(describing: error))
            }
        }

        semaphore.wait()

        async.task {
            do {
                let request = Request()

                let client = Client(host: "127.0.0.1", port: 5002)
                try client.connect()
                let response = try client.makeRequest(request)

                assertEqual(response.status, .ok)
                assertEqual(response.body, "Hello, World!")

                async.loop.terminate()
            } catch {
                async.loop.terminate()
                fail(String(describing: error))
            }
        }

        async.loop.run()
    }
}
