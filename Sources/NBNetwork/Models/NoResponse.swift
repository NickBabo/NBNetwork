import Foundation

/// Object defining an empty response.
/// Pass this type on the `responseType` parameter of `NBNetworkProtocol.request(_:responseType:completion:)`
/// method for requests in which there is no response object or the response object does not matter.
public struct NoResponse: Equatable, Codable { }
