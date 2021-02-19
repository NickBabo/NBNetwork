import Foundation
import Quick
import Nimble

@testable import NBNetwork

final class NBNetworkTests: QuickSpec {

    override func spec() {
        var sut: NBNetworkProtocol!
        var requestExecuterMock: NBRequestExecuterMock!
        var delegateMock: NBNetworkDelegateMock!

        beforeEach {
            requestExecuterMock = NBRequestExecuterMock()
            delegateMock = NBNetworkDelegateMock()
            mockRequest(ObjectMock())

            sut = NBNetwork(
                requestExecuter: requestExecuterMock,
                bundle: Bundle(for: BundleExtTests.self)
            )
        }

        describe("#init") {
            it("sets up the shared instance") {
                expect(NBNetwork.shared).toNot(beNil())
            }
        }

        describe("#set") {
            it("sets the delegate") {
                NBNetwork.set(delegate: delegateMock)

                expect(NBNetwork.shared.delegate).to(beAKindOf(NBNetworkDelegateMock.self))
            }
        }

        describe("#sessionConfig") {
            it("returns the expected session configuration") {
                let config = NBNetwork.sessionConfig

                expect(config.timeoutIntervalForRequest).to(equal(60.0))
                expect(config.timeoutIntervalForResource).to(equal(80.0))
            }
        }

        describe("#request") {
            it("requests a service and decodes the response into given type") {
                sut.request(ServiceMock(), responseType: ObjectMock.self) { result in
                    let expectedURL = URL(string: "base.url.test/example/path")
                    expect(requestExecuterMock.calledWithRequest?.url).to(equal(expectedURL))

                    switch result {
                    case .success(let objectMock):
                        expect(objectMock.id).to(equal(1))
                        expect(objectMock.name).to(equal("name"))
                    case .failure:
                        fail("FAIL - Expected request to succeed")
                    }
                }
            }

            context("unable to decode into given type") {
                beforeEach {
                    mockRequest(NoResponse())
                }

                it("returns a decodingError") {
                    sut.request(ServiceMock(), responseType: ObjectMock.self) { result in
                        switch result {
                        case .success:
                            fail("FAIL - Expected request to fail")
                        case .failure(let error):
                            expect(error).to(equal(.decodingError))
                        }
                    }
                }
            }

            context("bundle has no baseURL info") {
                beforeEach {
                    sut = NBNetwork(requestExecuter: requestExecuterMock,
                                    bundle: Bundle(for: NBNetwork.self))
                }

                it("returns an invalidBaseURL error") {
                    sut.request(ServiceMock(), responseType: ObjectMock.self) { result in
                        switch result {
                        case .success:
                            fail("FAIL - Expected request to fail")
                        case .failure(let error):
                            expect(error).to(equal(.invalidBaseURL))
                        }
                    }
                }
            }
        }

        func mockRequest(_ object: Encodable?, error: NBAPIError? = nil) {
            if let data = object?.encodeToData() {
                requestExecuterMock.mock(.success(data))
            } else {
                requestExecuterMock.mock(.failure(error!))
            }
        }
    }
}
