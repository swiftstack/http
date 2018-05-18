public struct URLParamMatcher {
    public let params: [(name: String, index: Int)]

    public init(_ url: String) {
        let components = url.split(separator: "/")
        var params: [(name: String, index: Int)] = []
        let count = components.count
        for (index, item) in components.enumerated() {
            if item.hasPrefix(":") {
                let name = String(item[item.index(after: item.startIndex)...])
                params.append((name, count - index))
            }
        }
        self.params = params.reversed()
    }

    public func match(from url: String) -> [String : String] {
        var dictionary: [String : String] = [:]

        let scalars = url.unicodeScalars
        var endIndex = scalars.endIndex
        var startIndex = scalars.index(before: endIndex)

        var nextIndex = 1
        for param in params {
            while true {
                guard nextIndex <= param.index else {
                    break
                }

                while startIndex > scalars.startIndex &&
                    scalars[startIndex] != "/" {
                        startIndex = scalars.index(before: startIndex)
                }

                if nextIndex == param.index {
                    let value = scalars[startIndex..<endIndex].dropFirst()
                    dictionary[param.name] = String(value)
                }
                guard startIndex > scalars.startIndex else {
                    break
                }
                endIndex = startIndex
                startIndex = scalars.index(before: endIndex)
                nextIndex += 1
            }
        }
        return dictionary
    }
}
