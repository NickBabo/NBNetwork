import NBNetwork

struct ServiceMock: NBServiceProtocol, Buildable {

    var path: String = "example/path"
    var method: NBHTTPMethod = .get
    var parameters: Encodable? = ParameterMock()
    var headers: [String: String]? = ["header": "example"]
    var queryParameters: [String: String]?
    var needsToken: Bool = false
}

class ParameterMock: Encodable {
    var parameter: String = "Example"
}
