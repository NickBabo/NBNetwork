import Foundation

/// The delegate protocol grouping all required behaviours that the main application must implement
/// in order to serve the NBNetwork with the needed informatioon
public typealias NBNetworkDelegate = NBNetworkTokenDelegate

/// Protocol to be implemented by classes responsible for handling token authentication.
/// This protocol must be implemented outside of the NBNetwork module's scope.
/// This delegate is a part of the NBNetworkDelegate.
public protocol NBNetworkTokenDelegate: AnyObject {

    /// Bearer Token. Method called when the `NBNetwork`` needs an authentication token to perform a request.
    func getToken() -> String?
    
}
