public protocol Inject {
    init()
}

public protocol InjectService {
    associatedtype One
    init(_ one: One)
}

public protocol Inject2Services {
    associatedtype One
    associatedtype Two
    init(_ one: One, _ two: Two)
}

public protocol Inject3Services {
    associatedtype One
    associatedtype Two
    associatedtype Three
    init(_ one: One, _ two: Two, _ three: Three)
}

public protocol Inject4Services {
    associatedtype One
    associatedtype Two
    associatedtype Three
    associatedtype Four
    init(_ one: One, _ two: Two, _ three: Three, _ four: Four)
}

public protocol Inject5Services {
    associatedtype One
    associatedtype Two
    associatedtype Three
    associatedtype Four
    associatedtype Five
    init(_ one: One, _ two: Two, _ three: Three, _ four: Four, _ five: Five)
}

public protocol Inject6Services {
    associatedtype One
    associatedtype Two
    associatedtype Three
    associatedtype Four
    associatedtype Five
    associatedtype Six
    init(
        _ one: One,
        _ two: Two,
        _ three: Three,
        _ four: Four,
        _ five: Five,
        _ six: Six
    )
}

extension RouterProtocol {
    public func addController<C>(_ type: C.Type) throws
        where C: Controller & Inject
    {
        try addController(C.self) {
            return C.init()
        }
    }

    public func addController<C>(_ type: C.Type) throws
        where C: Controller & InjectService
    {
        try check(type: C.One.self, for: C.self)

        try addController(C.self) {
            let one = try Services.shared.resolve(C.One.self)
            return C.init(one)
        }
    }

    public func addController<C>(_ type: C.Type) throws
        where C: Controller & Inject2Services
    {
        try check(type: C.One.self, for: C.self)
        try check(type: C.Two.self, for: C.self)

        try addController(C.self) {
            let one = try Services.shared.resolve(C.One.self)
            let two = try Services.shared.resolve(C.Two.self)
            return C.init(one, two)
        }
    }

    public func addController<C>(_ type: C.Type) throws
        where C: Controller & Inject3Services
    {
        try check(type: C.One.self, for: C.self)
        try check(type: C.Two.self, for: C.self)
        try check(type: C.Three.self, for: C.self)

        try addController(C.self) {
            let one = try Services.shared.resolve(C.One.self)
            let two = try Services.shared.resolve(C.Two.self)
            let three = try Services.shared.resolve(C.Three.self)
            return C.init(one, two, three)
        }
    }

    public func addController<C>(_ type: C.Type) throws
        where C: Controller & Inject4Services
    {
        try check(type: C.One.self, for: C.self)
        try check(type: C.Two.self, for: C.self)
        try check(type: C.Three.self, for: C.self)
        try check(type: C.Four.self, for: C.self)

        try addController(C.self) {
            let one = try Services.shared.resolve(C.One.self)
            let two = try Services.shared.resolve(C.Two.self)
            let three = try Services.shared.resolve(C.Three.self)
            let four = try Services.shared.resolve(C.Four.self)
            return C.init(one, two, three, four)
        }
    }

    public func addController<C>(_ type: C.Type) throws
        where C: Controller & Inject5Services
    {
        try check(type: C.One.self, for: C.self)
        try check(type: C.Two.self, for: C.self)
        try check(type: C.Three.self, for: C.self)
        try check(type: C.Four.self, for: C.self)
        try check(type: C.Five.self, for: C.self)

        try addController(C.self) {
            let one = try Services.shared.resolve(C.One.self)
            let two = try Services.shared.resolve(C.Two.self)
            let three = try Services.shared.resolve(C.Three.self)
            let four = try Services.shared.resolve(C.Four.self)
            let five = try Services.shared.resolve(C.Five.self)
            return C.init(one, two, three, four, five)
        }
    }

    public func addController<C>(_ type: C.Type) throws
        where C: Controller & Inject6Services
    {
        try check(type: C.One.self, for: C.self)
        try check(type: C.Two.self, for: C.self)
        try check(type: C.Three.self, for: C.self)
        try check(type: C.Four.self, for: C.self)
        try check(type: C.Five.self, for: C.self)
        try check(type: C.Six.self, for: C.self)

        try addController(C.self) {
            let one = try Services.shared.resolve(C.One.self)
            let two = try Services.shared.resolve(C.Two.self)
            let three = try Services.shared.resolve(C.Three.self)
            let four = try Services.shared.resolve(C.Four.self)
            let five = try Services.shared.resolve(C.Five.self)
            let six = try Services.shared.resolve(C.Six.self)
            return C.init(one, two, three, four, five, six)
        }
    }
}
