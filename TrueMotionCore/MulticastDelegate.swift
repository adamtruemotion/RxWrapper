open class MulticastDelegate <T> {
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    public init() {}

    public func add(delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    public func remove(delegate: T) {
        for oneDelegate in delegates.allObjects.reversed() {
            if oneDelegate === delegate as AnyObject {
                delegates.remove(oneDelegate)
            }
        }
    }

    public func invoke(invocation: (T) -> ()) {
        for delegate in delegates.allObjects.reversed() {
            invocation(delegate as! T)
        }
    }
}

public protocol MulticastDelegateProtocol {
    associatedtype T
    func add(delegate: T)
    func remove(delegate: T)
    func invoke(invocation: (T) -> ())
}
