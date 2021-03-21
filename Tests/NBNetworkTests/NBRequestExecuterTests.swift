import Foundation
import Quick
import Nimble

@testable import NBNetwork

final class NBRequestExecuterTests: QuickSpec {

    override func spec() {
        var sut: NBRequestExecuter!
        var mockSession: URLSessionMock!
        var mockDataTask: DataTaskMock!

        beforeEach {
            mockDataTask = DataTaskMock()
            mockSession = URLSessionMock(dataTaskMock: mockDataTask)
            sut = NBRequestExecuter(session: mockSession)
        }

        describe("#execute") {
            beforeEach {
                mock(data: ObjectMock(), statusCode: 200)
            }

            it("returns a response data") {
                sut.execute(request: createRequest()) { result in
                    switch result {
                    case .success(let data):
                        expect(data).to(equal(ObjectMock().encodeToData()))
                        expect(mockDataTask.resumeWasCalled).to(beTrue())
                    case .failure:
                        fail("FAIL - Expected request to succeed")
                    }
                }
            }

            context("when status code is not in success range") {
                beforeEach {
                    mock(data: ObjectMock(), statusCode: 500)
                }

                it("returns a .error with specific statusCode") {
                    sut.execute(request: createRequest()) { result in
                        switch result {
                        case .success:
                            fail("FAIL - Expected request to fail")
                        case .failure(let error):
                            expect(error).to(equal(.error(500)))
                        }
                    }
                }
            }

            context("when response data is empty") {
                beforeEach {
                    mock(data: nil, statusCode: 200)
                }

                it("returns a noData error") {
                    sut.execute(request: createRequest()) { result in
                        switch result {
                        case .success:
                            fail("FAIL - Expected request to fail")
                        case .failure(let error):
                            expect(error).to(equal(.noData))
                        }
                    }
                }
            }

            context("when response is not of HTTPURLResponse type") {
                beforeEach {
                    mockNoResponse()
                }

                it("returns a noResponse error") {
                    sut.execute(request: createRequest()) { result in
                        switch result {
                        case .success:
                            fail("FAIL - Expected request to fail")
                        case .failure(let error):
                            expect(error).to(equal(.noResponse))
                        }
                    }
                }
            }
        }

        func createRequest() -> URLRequest {
            var request = URLRequest(url: URL(string: "network.teste/url")!)
            request.allHTTPHeaderFields = ["key": "value"]
            return request
        }

        func mock(data: Encodable?, statusCode: Int) {
            let response = HTTPURLResponse(url: URL(string: "network.teste/url")!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: nil)

            mockSession.mock(data: data?.encodeToData(),
                             response: response)
        }

        func mockNoResponse() {
            mockSession.mock(data: nil, response: URLResponse())
        }
    }

}
