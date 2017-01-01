//public protocol HashableSequence: Sequence, Hashable {}
//public extension HashableSequence where Iterator.Element == UInt8 {
//    public var hashValue: Int {
//        var hash = 5381
//        for byte in self {
//            hash = ((hash << 5) &+ hash) &+ Int(byte | 0x20)
//        }
//        return hash
//    }
//}

typealias ASCII = [UInt8]
extension Sequence where Iterator.Element == UInt8 {
    public init(_ value: String) {
        let bytes = [UInt8](value.utf8)
        self = bytes as! Self
    }
}

extension String {
    public init(slice: ArraySlice<UInt8>) {
        self = String(cString: Array(slice + [0]))
    }
    public init(bytes: [UInt8]) {
        self = String(cString: bytes + [0])
    }
}

extension RandomAccessCollection where Iterator.Element == UInt8 {
    var slice: ArraySlice<UInt8> {
        return ArraySlice(self)
    }
}

extension ArraySlice where Element: Equatable {
    func contains(other: ArraySlice<Element>) -> Bool {
        if self.count == other.count {
            return self.elementsEqual(other)
        }

        let maximumStart = self.endIndex.advanced(by: -other.count)
        var index = self.startIndex
        while index <= maximumStart {
            if self[index..<index.advanced(by: other.count)].elementsEqual(other) {
                return true
            }
            index = index.advanced(by: 1)
        }
        return false
    }
}
