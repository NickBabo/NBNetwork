import Foundation

protocol URLDataTaskProtocol {

    func resume()

}

extension URLSessionDataTask: URLDataTaskProtocol {}
