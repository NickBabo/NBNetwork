import Foundation

/// Enumeration defining the possible errors to be returned in the completion of a request.
public enum NBAPIError: Error, Equatable {

    case noResponse
    case noData
    /// Returned when NBNetwork is unable to decode the data response into the specified object.
    /// You can utilize the `NBNetwork.request(...)` to bypass the decoding step.
    case decodingError
    /// Returned when NBNetwork is unable to fetch the base URL to be used.
    /// The base URL must be configured in a `.xcconfig` file by defining the `NB_BASE_URL` variable.
    case invalidBaseURL
    /// Returned when the response's status code is not a success code.
    /// - Parameter statusCode: The status code received in the response
    case error(_ statusCode: Int)
    
}
