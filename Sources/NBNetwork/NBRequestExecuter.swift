import Foundation

protocol NBRequestExecuterProtocol {

    func execute(request: URLRequest, completion: NBAPIResult?)
    
}

final class NBRequestExecuter: NBRequestExecuterProtocol {

    private var successCodes: Range<Int> = 200..<299

    private let session: URLSessionProtocol

    init(session: URLSessionProtocol) {
        self.session = session
    }

    func execute(request: URLRequest, completion: NBAPIResult?) {
        NBNetworkLogger.log(request: request)

        let dataTask = session.task(with: request) { data, response, error in
            DispatchQueue.main.async {

                guard let response = response as? HTTPURLResponse else {
                    completion?(.failure(.noResponse))
                    return
                }

                NBNetworkLogger.log(data: data, response: response)

                guard self.successCodes.contains(response.statusCode) else {
                    completion?(.failure(.error(response.statusCode)))
                    return
                }

                guard let data = data else {
                    completion?(.failure(.noData))
                    return
                }

                completion?(.success(data))
            }
        }

        DispatchQueue.global().async {
            dataTask.resume()
        }
    }

}
