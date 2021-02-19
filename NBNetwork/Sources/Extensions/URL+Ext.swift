import Foundation

extension URL {

    @discardableResult
    mutating func appendQueryItems(_ queryItems: [URLQueryItem]) -> Self {
        guard !queryItems.isEmpty else { return self }

        var component = URLComponents(url: self, resolvingAgainstBaseURL: false)
        component?.queryItems = queryItems

        guard let newURL = component?.url else {
            return self
        }

        self = newURL
        return self
    }
    
}
