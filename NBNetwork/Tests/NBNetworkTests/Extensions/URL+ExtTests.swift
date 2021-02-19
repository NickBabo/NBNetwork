import Quick
import Nimble

@testable import NBNetwork

final class URLExtTests: QuickSpec {

    override func spec() {
        var sut: URL!

        beforeEach {
            sut = URL(string: "http://localhost:8080/path")
        }

        describe("appendQueryItems") {
            beforeEach {
                let queryItems = [URLQueryItem(name: "query", value: "example"),
                                  URLQueryItem(name: "var", value: "1")]
                sut.appendQueryItems(queryItems)
            }

            it("appends query items to the end of the path") {
                let expectedString = "http://localhost:8080/path?query=example&var=1"

                expect(sut.absoluteString).to(equal(expectedString))
            }

            context("empty query items") {
                beforeEach {
                    sut = URL(string: "http://localhost:8080/path")
                    sut.appendQueryItems([])
                }

                it("retuns the original URL") {
                    expect(sut.absoluteString).to(equal("http://localhost:8080/path"))
                }
            }

            context("invalid URL") {
                beforeEach {
                    sut = URL(string: "http://localhost:8080wrongpath")
                    let queryItems = [URLQueryItem(name: "query", value: "example"),
                                      URLQueryItem(name: "var", value: "1")]
                    sut.appendQueryItems(queryItems)
                }

                it("retuns the original URL") {
                    expect(sut.absoluteString).to(equal("http://localhost:8080wrongpath"))
                }
            }
        }

    }

}
