open class MulticastDelegateImpl <T>: MulticastDelegate {
    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    public init() {}

    public func add(delegate: T) {
        delegates.add(delegate as AnyObject)
    }

    public func remove(delegate: T) {
        for oneDelegate in delegates.allObjects {
            if oneDelegate === delegate as AnyObject {
                delegates.remove(oneDelegate)
            }
        }
    }

    public func invoke(invocation: (T) -> ()) {
        // TODO: order
        for delegate in delegates.allObjects {
            invocation(delegate as! T)
        }
    }
}

public protocol MulticastDelegate {
    associatedtype T
    func add(delegate: T)
    func remove(delegate: T)
    func invoke(invocation: (T) -> ())
}
