import Foundation

struct RequestHeaderManager {

    weak var delegate: NBNetworkTokenDelegate?

    func buildHeaders(needsToken: Bool) -> [String: String] {
        let defaultHeaders = buildDefaultHeaders()
        let authorizationHeader = buildAuthorizationHeader(needsToken)

        return defaultHeaders.merging(authorizationHeader) { $1 }
    }

    private func buildDefaultHeaders() -> [String: String] {
        [
            "Content-Type": "application/json; charset=UTF-8"
        ]
    }

    private func buildAuthorizationHeader(_ needsToken: Bool) -> [String: String] {
        guard needsToken,
            let token = delegate?.getToken() else { return [:] }

        return ["Authorization": "Bearer \(token)"]
    }

}
