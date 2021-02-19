import Quick
import Nimble

@testable import NBNetwork

final class NBAPIErrorTests: QuickSpec {

    override func spec() {
        var sut: NBAPIError!

        describe("#noResponse") {
            beforeEach {
                sut = .noResponse
            }

            it("has the expected localized description") {
                let expectedString = "No Response"

                expect(sut.localizedDescription).to(equal(expectedString))
            }
        }

        describe("#noData") {
            beforeEach {
                sut = .noData
            }

            it("has the expected localized description") {
                let expectedString = "No Data - Data object received in response is empty"

                expect(sut.localizedDescription).to(equal(expectedString))
            }
        }

        describe("#decodingErrorDescription") {
            beforeEach {
                sut = .decodingError
            }

            it("has the expected localized description") {
                let expectedString = "Decoding Error - Unable to decode received data into desired object"

                expect(sut.localizedDescription).to(equal(expectedString))
            }
        }

        describe("#invalidBaseURLDescription") {
            beforeEach {
                sut = .invalidBaseURL
            }

            it("has the expected localized description") {
                let expectedString = "Invalid Base URL - Unable to find Base URL specification"

                expect(sut.localizedDescription).to(equal(expectedString))
            }
        }

        describe("#statusCodeErrorDescription") {
            beforeEach {
                sut = .error(404)
            }

            it("has the expected localized description") {
                let expectedString = "Internal Server Error - Status Code: 404"

                expect(sut.localizedDescription) == expectedString
            }
        }
    }

}
