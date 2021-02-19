import Quick
import Nimble

@testable import NBNetwork

final class EncodableExtTests: QuickSpec {

    override func spec() {
        describe("#encodeToData") {
            var encoder: JSONEncoder!

            beforeEach {
                encoder = JSONEncoder()
            }

            it("transforms an Encodable object into data") {
                let expectedData = try! encoder.encode(ObjectMock())

                expect(ObjectMock().encodeToData()).to(equal(expectedData))
            }

            it("uses the default keyEncodingStrategy strategy") {
                encoder.keyEncodingStrategy = .convertToSnakeCase

                let snakeCaseData = try? encoder.encode(ObjectMock())

                expect(ObjectMock().encodeToData()).toNot(equal(snakeCaseData))
            }
        }
    }
}
