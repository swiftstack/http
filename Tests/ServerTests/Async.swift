import Async
import Dispatch
import Foundation

class TestAsyncLoop: AsyncLoop {
    var terminate = false

    func run() {
        while !terminate {
            RunLoop.main.run(until: Date().addingTimeInterval(0.01))
        }
    }

    func stop() {
        terminate = true
    }

    func run(until: Date) {
        fatalError("not implemented")
    }
}

class TestAsync: Async {
    let awaiter: IOAwaiter? = nil
    let loop: AsyncLoop = TestAsyncLoop()

    func breakLoop() {
        (loop as! TestAsyncLoop).stop()
    }

    func task(_ closure: @escaping AsyncTask) {
        DispatchQueue.global(qos: .userInitiated).async(execute: closure)
    }

    func syncTask<T>(
        onQueue queue: DispatchQueue,
        qos: DispatchQoS,
        deadline: Date,
        task: @escaping () throws -> T
    ) throws -> T {
        return try task()
    }

    func sleep(until deadline: Date) {
        fatalError("not implemented")
    }

    func testCancel() throws {
        fatalError("not implemented")
    }
}
