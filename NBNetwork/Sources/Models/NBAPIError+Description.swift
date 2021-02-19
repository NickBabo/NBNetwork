public extension NBAPIError {

    var localizedDescription: String {
        switch self {
        case .noResponse: return NBLocalized.string(.noResponseDescription)
        case .noData: return NBLocalized.string(.noDataDescription)
        case .invalidBaseURL: return NBLocalized.string(.invalidBaseURLDescription)
        case .decodingError: return NBLocalized.string(.decodingErrorDescription)
        case .error(let statusCode):
            return NBLocalized.formatted(
                string: .statusCodeErrorDescription,
                arguments: [statusCode.description]
            )
        }
    }
    
}
