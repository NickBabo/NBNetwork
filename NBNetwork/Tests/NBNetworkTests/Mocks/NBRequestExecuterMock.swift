import Foundation
@testable import NBNetwork

final class NBRequestExecuterMock: NBRequestExecuterProtocol {

    var calledWithRequest: URLRequest?

    private var mockedResult: Result<Data, NBAPIError>?

    func mock(_ result: Result<Data, NBAPIError>?) {
        self.mockedResult = result
    }

    func execute(request: URLRequest, completion: NBAPIResult?) {
        self.calledWithRequest = request

        if let mockedResult = mockedResult {
            completion?(mockedResult)
        }
    }
}
