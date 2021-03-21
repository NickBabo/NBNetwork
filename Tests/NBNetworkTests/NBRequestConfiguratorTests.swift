import Foundation
import Quick
import Nimble

@testable import NBNetwork

final class NBRequestConfiguratorTests: QuickSpec {

    override func spec() {
        var sut: NBRequestConfigurator!
        var serviceMock: ServiceMock!
        var delegateMock: NBNetworkDelegateMock!

        beforeEach {
            delegateMock = NBNetworkDelegateMock()
            serviceMock = ServiceMock()
            sut = NBRequestConfigurator(baseURL: URL(string: "base.url.teste/")!,
                                        delegate: delegateMock)
        }

        describe("#configure") {
            it("correctly configures a request given a service") {
                let expectedPath = URL(string: "base.url.teste/example/path")!
                let expectedHTTPMethod = "GET"
                let expectedParameters = try? JSONEncoder().encode(ParameterMock())
                let expectedHeader = [
                    "Content-Type": "application/json; charset=UTF-8",
                    "header": "example"
                ]

                expect(sut.configure(serviceMock).url).to(equal(expectedPath))
                expect(sut.configure(serviceMock).httpMethod).to(equal(expectedHTTPMethod))
                expect(sut.configure(serviceMock).httpBody).to(equal(expectedParameters))
                expect(sut.configure(serviceMock).allHTTPHeaderFields).to(equal(expectedHeader))
            }

            context("no parameters") {
                beforeEach {
                    serviceMock = serviceMock.with(\.parameters, nil)
                }

                it("correctly configures a request given a service") {
                    let expectedPath = URL(string: "base.url.teste/example/path")!
                    let expectedHTTPMethod = "GET"
                    let expectedHeader = [
                        "Content-Type": "application/json; charset=UTF-8",
                        "header": "example"
                    ]

                    expect(sut.configure(serviceMock).url).to(equal(expectedPath))
                    expect(sut.configure(serviceMock).httpMethod).to(equal(expectedHTTPMethod))
                    expect(sut.configure(serviceMock).httpBody).to(beNil())
                    expect(sut.configure(serviceMock).allHTTPHeaderFields).to(equal(expectedHeader))
                }
            }

            context("no headers") {
                beforeEach {
                    serviceMock = serviceMock.with(\.headers, nil)
                }

                it("correctly configures a request given a service") {
                    let expectedPath = URL(string: "base.url.teste/example/path")!
                    let expectedHTTPMethod = "GET"
                    let expectedParameters = try? JSONEncoder().encode(ParameterMock())
                    let expectedHeader = [
                        "Content-Type": "application/json; charset=UTF-8"
                    ]

                    expect(sut.configure(serviceMock).url).to(equal(expectedPath))
                    expect(sut.configure(serviceMock).httpMethod).to(equal(expectedHTTPMethod))
                    expect(sut.configure(serviceMock).httpBody).to(equal(expectedParameters))
                    expect(sut.configure(serviceMock).allHTTPHeaderFields).to(equal(expectedHeader))
                }
            }

            context("needs token") {
                beforeEach {
                    serviceMock = serviceMock.with(\.needsToken, true)
                }

                it("correctly configures the Authorization Header") {
                    let expectedPath = URL(string: "base.url.teste/example/path")!
                    let expectedHTTPMethod = "GET"
                    let expectedParameters = try? JSONEncoder().encode(ParameterMock())
                    let expectedHeader = [
                        "Content-Type": "application/json; charset=UTF-8",
                        "Authorization": "Bearer token_mock",
                        "header": "example"
                    ]

                    expect(sut.configure(serviceMock).url).to(equal(expectedPath))
                    expect(sut.configure(serviceMock).httpMethod).to(equal(expectedHTTPMethod))
                    expect(sut.configure(serviceMock).httpBody).to(equal(expectedParameters))
                    expect(sut.configure(serviceMock).allHTTPHeaderFields).to(equal(expectedHeader))
                }
            }

            context("with query parameters") {
                beforeEach {
                    serviceMock = serviceMock.with(\.queryParameters, ["query": "example"])
                }

                it("correctly configures a request given a service") {
                    let expectedPath = URL(string: "base.url.teste/example/path?query=example")!
                    let expectedHTTPMethod = "GET"
                    let expectedParameters = try? JSONEncoder().encode(ParameterMock())
                    let expectedHeader = [
                        "Content-Type": "application/json; charset=UTF-8",
                        "header": "example"
                    ]

                    expect(sut.configure(serviceMock).url).to(equal(expectedPath))
                    expect(sut.configure(serviceMock).httpMethod).to(equal(expectedHTTPMethod))
                    expect(sut.configure(serviceMock).httpBody).to(equal(expectedParameters))
                    expect(sut.configure(serviceMock).allHTTPHeaderFields).to(equal(expectedHeader))
                }
            }
        }
    }
    
}
