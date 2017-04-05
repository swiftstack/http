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
    var loop: AsyncLoop

    init() {
        self.loop = TestAsyncLoop()
    }

    func breakLoop() {
        (loop as! TestAsyncLoop).stop()
    }

    var task: (@escaping AsyncTask) -> Void = { task in
        DispatchQueue.global(qos: .userInitiated).async(execute: task)
    }

    var awaiter: IOAwaiter? = nil
}
