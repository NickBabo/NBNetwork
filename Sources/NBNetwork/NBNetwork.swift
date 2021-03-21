import Foundation

/// A customization of `Swift.Result` type which returns a `Data` object on success and a `NBAPIError` on failure
public typealias NBAPIResult = (Result<Data, NBAPIError>) -> Void

/// Object utilized for configuring and executing requests. Access it by using the `NBNetwork.shared` property.
public class NBNetwork: NBNetworkProtocol {

    private var configuration: NBNetworkConfiguration?
    private let requestExecuter: NBRequestExecuterProtocol
    /// The delegate object that will be called to handle operations outside of the NBNetwork module's scope,
    /// such as authentication token handling. Please use the method `NBNetwork.set(delegate:)` to setup this delegate.
    public weak var delegate: NBNetworkDelegate?

    private static var sharedInstance: NBNetworkProtocol = {
        let session = URLSession(configuration: sessionConfig)
        return NBNetwork(requestExecuter: NBRequestExecuter(session: session))
    }()

    /// Singleton instance of NBNetwork. Use this shared instance to communicate with the `NBNetwork` module.
    public static var shared: NBNetworkProtocol {
        sharedInstance
    }

    private(set) static var sessionConfig: URLSessionConfiguration = {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 60.0
        sessionConfig.timeoutIntervalForResource = 80.0
        return sessionConfig
    }()

    var baseURL: URL? {
        guard let url: String = configuration?.baseURL,
            let baseURL = URL(string: url) else {
                return nil
        }
        return baseURL
    }

    init(requestExecuter: NBRequestExecuterProtocol) {
        self.requestExecuter = requestExecuter
    }

    /// Sets up a delegate object for the NBNetwork's shared instance.
    /// - Parameter delegate: An object conforming to the `NBNetworkDelegate` protocol.
    /// Responsible for handling anything needed for a request that is outside the NBNetwork module's scope,
    /// such as authentication token handling.
    public static func set(delegate: NBNetworkDelegate) {
        NBNetwork.sharedInstance.delegate = delegate
    }
    
}

// MARK: NBNetwork - ServiceRequester

extension NBNetwork: ServiceRequester {

    /// Executes a request based on the service passed. The service must conform to `NBServiceProtocol`.
    /// - Parameter service: Service object. Serves for configuring the request to be executed.
    /// - Parameter completion: The completion that will be executed when NBNetwork receives a response.
    /// This completion will return a data object on it's success case.
    /// If you wish to receive an already decoded object,
    /// please use the `NBNetworkProtocol.request(_:responseType:completion:)` function
    public func request(
        _ service: NBServiceProtocol,
        _ completion: @escaping (Result<Data, NBAPIError>) -> Void
    ) {

        guard let baseURL = baseURL else {
            completion(.failure(.invalidBaseURL))
            return
        }

        let request = NBRequestConfigurator(
            baseURL: baseURL,
            delegate: delegate
        ).configure(service)

        requestExecuter.execute(request: request, completion: completion)
    }

}

extension NBNetwork {

    @discardableResult
    public func configure(baseURL: String) -> NBNetworkProtocol {
        configuration = NBNetworkConfiguration(baseURL: baseURL)
        return self
    }

}
