import Foundation

public struct URLParamMatcher {
    let params: [(name: String, index: Int)]

    public init(_ url: String) {
        let components = url.components(separatedBy: "/")
        var params: [(name: String, index: Int)] = []
        for (index, item) in components.enumerated() {
            if item.hasPrefix(":") {
                let name = String(item[item.index(after: item.startIndex)...])
                params.append((name, index))
            }
        }
        self.params = params
    }

    public func match(from url: String) -> [String : String] {
        var dictionary: [String : String] = [:]

        let unicode = url.unicodeScalars
        var startIndex = unicode.index(after: unicode.startIndex)
        var endIndex = unicode.index(after: startIndex)

        var current = 1
        for param in params {
            while true {
                while endIndex < unicode.endIndex && unicode[endIndex] != "/" {
                    endIndex = unicode.index(after: endIndex)
                }
                if current == param.index {
                    dictionary[param.name] = String(unicode[startIndex..<endIndex])
                }
                guard endIndex != unicode.endIndex else {
                    break
                }
                startIndex = unicode.index(after: endIndex)
                endIndex = unicode.index(after: startIndex)
                current += 1
            }
        }
        return dictionary
    }
}
