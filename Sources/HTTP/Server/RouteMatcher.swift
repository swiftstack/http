enum RouterError: Swift.Error {
    case invalidRoute
    case notFound
}

public struct RouteMatcher<T> {
    struct Node {
        var payload: [T] = []
        var wildcard: [Node]? = nil
        var rlist: [Node]? = nil
    }

    var root = Node()

    public init() {}

    public mutating func add(route bytes: UnsafeRawBufferPointer, payload: T) {
        guard bytes.count > 0, bytes[0] == .slash else {
            return
        }

        // main route: "/"
        guard bytes.count > 1 else {
            root.payload.append(payload)
            return
        }

        addNode(to: &root, characters: bytes.dropFirst(), payload: payload)
    }

    public func matches(route bytes: UnsafeRawBufferPointer) -> [T] {
        let startIndex = bytes.startIndex
        guard bytes[startIndex] == .slash else {
            return []
        }

        let route = bytes.dropFirst()
        guard route.count > 0 else {
            if root.wildcard != nil {
                return root.payload +
                    root.wildcard![.asterisk].payload
            }
            return root.payload
        }

        var result = [T]()
        findNode(in: root, characters: route, result: &result)
        return result
    }

    func addNode(to node: inout Node, characters: UnsafeRawBufferPointer.SubSequence, payload: T) {
        let character = characters[characters.startIndex]
        if character == .asterisk || character == .colon {
            if node.wildcard == nil {
                node.wildcard = [Node](repeating: Node(), count: Int(UInt8.max))
            }

            var index = characters.startIndex
            while index < characters.endIndex && characters[index] != .slash {
                characters.formIndex(after: &index)
            }

            guard index < characters.endIndex else {
                node.wildcard![.asterisk].payload.append(payload)
                return
            }

            guard characters.index(after: index) < characters.endIndex else {
                node.wildcard![.slash].payload.append(payload)
                return
            }

            let next = characters.index(after: index)
            addNode(to: &node.wildcard![.slash], characters: characters[next...], payload: payload)
        } else {
            if node.rlist == nil {
                node.rlist = [Node](repeating: Node(), count: Int(UInt8.max))
            }

            guard characters.index(after: characters.startIndex) < characters.endIndex else {
                node.rlist![Int(character)].payload.append(payload)
                return
            }

            let next = characters.index(after: characters.startIndex)
            addNode(to: &node.rlist![Int(character)], characters: characters[next...], payload: payload)
        }
    }

    func findNode(in node: Node, characters: UnsafeRawBufferPointer.SubSequence, result: inout [T]) {
        guard characters.startIndex < characters.endIndex else {
            if node.payload.count > 0 {
                result.append(contentsOf: node.payload)
            }
            return
        }

        if let rlist = node.rlist  {
            let childNode = rlist[Int(characters[characters.startIndex])]
            let next = characters.index(after: characters.startIndex)
            findNode(in: childNode, characters: characters[next...], result: &result)
        }

        if let wildcard = node.wildcard {
            var index = characters.startIndex
            while characters.index(after: index) < characters.endIndex && characters[index] != .slash {
                characters.formIndex(after: &index)
            }

            let childNode = characters[index] == .slash ?
                wildcard[.slash] :
                wildcard[.asterisk]

            let next = characters.index(after: index)
            findNode(in: childNode, characters: characters[next...], result: &result)
        }
    }
}

extension RouteMatcher {
    public mutating func add(route: String, payload: T) {
        let bytes = [UInt8](route.utf8)
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        add(route: buffer, payload: payload)
    }

    public func matches(route: String) -> [T] {
        let bytes = [UInt8](route.utf8)
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        return matches(route: buffer)
    }

    public mutating func first(route: String) -> T? {
        return matches(route: route).first
    }
}

extension Int {
    static let asterisk = Int(UInt8.asterisk)
    static let colon = Int(UInt8.colon)
    static let slash = Int(UInt8.slash)
}
