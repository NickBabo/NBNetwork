import Foundation

public protocol Buildable {}

public extension Buildable {

    @discardableResult
    func with<T>(_ keyPath: WritableKeyPath<Self, T>, _ value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }

    @discardableResult
    func with<T>(_ keyPath: WritableKeyPath<Self, T?>, _ value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = .some(value)
        return copy
    }
    
}
