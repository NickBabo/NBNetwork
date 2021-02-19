import Foundation
import Quick
import Nimble

@testable import NBNetwork

final class URLSessionMock: URLSessionProtocol {

    private var data: Data?
    private var response: URLResponse?

    var dataTaskMock: DataTaskMock

    init(dataTaskMock: DataTaskMock) {
        self.dataTaskMock = dataTaskMock
    }

    func mock(data: Data?, response: URLResponse?) {
        self.data = data
        self.response = response
    }

    func task(with request: URLRequest,
              completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLDataTaskProtocol {
        completionHandler(data, response, nil)
        return dataTaskMock
    }
}

final class DataTaskMock: URLDataTaskProtocol {
    var resumeWasCalled: Bool = false

    func resume() {
        resumeWasCalled = true
    }
}
