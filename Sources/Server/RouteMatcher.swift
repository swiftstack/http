let asterisk = [UInt8]("*".utf8)[0]
let colon = [UInt8](":".utf8)[0]
let separator = [UInt8]("/".utf8)[0]

enum RouterError: Error {
    case invalidRoute
}

struct Node<T> {
    lazy var payload: [T] = []
    var wildcard: [Node]? = nil
    var rlist: [Node]? = nil
}

public struct RouteMatcher<T> {
    public init() {}

    var root = Node<T>()

    public mutating func add(route bytes: [UInt8], payload: T) {
        guard bytes.count > 0, bytes[0] == separator else {
            return
        }

        // ascii table
        for byte in bytes {
            guard byte >= 0 && byte < 128 else {
                return
            }
        }

        // main route: "/"
        guard bytes.count > 1 else {
            root.payload.append(payload)
            return
        }

        addNode(to: &root, characters: bytes.suffix(from: 1), payload: payload)
    }

    public mutating func matches(route bytes: [UInt8]) -> [T] {
        guard bytes[0] == separator else {
            return []
        }

        // ascii table
        for byte in bytes {
            guard byte >= 0 && byte < 128 else {
                return []
            }
        }

        let route = bytes.suffix(from: 1)
        guard route.count > 0 else {
            if root.wildcard != nil {
                return root.payload + root.wildcard![Int(asterisk)].payload
            }
            return root.payload
        }

        var result = [T]()
        findNode(in: root, characters: route, result: &result)
        return result
    }

    func addNode(to node: inout Node<T>, characters: ArraySlice<UInt8>, payload: T) {
        let character = Int(characters[characters.startIndex])
        if character == Int(asterisk) || character == Int(colon) {
            if node.wildcard == nil {
                node.wildcard = [Node](repeating: Node(), count: 128)
            }

            var index = characters.startIndex
            while index < characters.endIndex && characters[index] != separator {
                index += 1
            }

            guard index < characters.endIndex else {
                node.wildcard![Int(asterisk)].payload.append(payload)
                return
            }

            guard index < characters.endIndex - 1 else {
                node.wildcard![Int(separator)].payload.append(payload)
                return
            }

            let next = index.advanced(by: 1)
            addNode(to: &node.wildcard![Int(separator)], characters: characters.suffix(from: next), payload: payload)
        } else {
            if node.rlist == nil {
                node.rlist = [Node](repeating: Node(), count: 128)
            }

            guard characters.startIndex < characters.endIndex - 1 else {
                node.rlist![character].payload.append(payload)
                return
            }

            let next = characters.startIndex.advanced(by: 1)
            addNode(to: &node.rlist![character], characters: characters.suffix(from: next), payload: payload)
        }
    }

    mutating func findNode(in node: Node<T>, characters: ArraySlice<UInt8>, result: inout [T]) {
        guard characters.startIndex < characters.endIndex else {
            var node = node // accessing lazy initializer on immutable type
            if node.payload.count > 0 {
                result.append(contentsOf: node.payload)
            }
            return
        }

        if let rlist = node.rlist  {
            let childNode = rlist[Int(characters[characters.startIndex])]
            let next = characters.startIndex.advanced(by: 1)
            findNode(in: childNode, characters: characters.suffix(from: next), result: &result)
        }

        if let wildcard = node.wildcard {
            var index = characters.startIndex
            while index < characters.endIndex - 1 && characters[index] != separator {
                index += 1
            }

            let childNode = characters[index] == separator ?
                wildcard[Int(separator)] :
                wildcard[Int(asterisk)]

            let next = index.advanced(by: 1)
            findNode(in: childNode, characters: characters.suffix(from: next), result: &result)
        }
    }
}

extension RouteMatcher {
    public mutating func add(route: String, payload: T) {
        let bytes = [UInt8](route.utf8)
        add(route: bytes, payload: payload)
    }

    public mutating func matches(route: String) -> [T] {
        let bytes = [UInt8](route.utf8)
        return matches(route: bytes)
    }

    public mutating func first(route: [UInt8]) -> T? {
        return matches(route: route).first
    }

    public mutating func first(route: String) -> T? {
        return matches(route: route).first
    }
}
