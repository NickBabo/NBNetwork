import Foundation

final class NBRequestConfigurator {

    private let baseURL: URL
    weak var delegate: NBNetworkTokenDelegate?

    init(baseURL: URL, delegate: NBNetworkTokenDelegate?) {
        self.baseURL = baseURL
        self.delegate = delegate
    }

    func configure(_ service: NBServiceProtocol) -> URLRequest {
        let serviceURL = baseURL.appendingPathComponent(service.path)
        var request = URLRequest(url: serviceURL)

        request.httpMethod = service.method.rawValue

        configureHeaders(service.headers, needsToken: service.needsToken, to: &request)
        configureBody(service.parameters, to: &request)
        configureQueryParameters(service.queryParameters, to: &request)

        return request
    }

    private func configureBody(_ parameter: Encodable?, to request: inout URLRequest) {
        guard let parameter = parameter,
            let data = parameter.encodeToData() else { return }

        request.httpBody = data
    }

    private func configureHeaders(
        _ headers: [String: String]?,
        needsToken: Bool,
        to request: inout URLRequest
    ) {

        let headerManager = RequestHeaderManager(delegate: delegate)
        let serviceHeaders = headers ?? [:]

        let headers = headerManager
            .buildHeaders(needsToken: needsToken)
            .merging(serviceHeaders) { $1 }

        request.allHTTPHeaderFields = headers
    }

    private func configureQueryParameters(
        _ queryParameters: [String: String]?,
        to request: inout URLRequest
    ) {
        guard let queryParameters = queryParameters,
            !queryParameters.isEmpty else { return }

        let queryItems = queryParameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        request.url?.appendQueryItems(queryItems)
    }

}
