import Foundation

protocol URLSessionProtocol {

    func task(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLDataTaskProtocol
    
}

extension URLSession: URLSessionProtocol {

    func task(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLDataTaskProtocol {
        dataTask(with: request, completionHandler: completionHandler) as URLDataTaskProtocol
    }

}
