import Foundation
import Quick
import Nimble

@testable import NBNetwork

final class URLSessionExtTests: QuickSpec {

    override func spec() {
        var sut: URLSession!
        var request: URLRequest!
        var completionHandler: ((Data?, URLResponse?, Error?) -> Void)!

        beforeEach {
            completionHandler = { _, _, _ in }
            request = URLRequest(url: URL(string: "url.session.test/path")!)
            sut = URLSession(configuration: .default)
        }

        describe("#task") {
            it("returns a URLSessionDataTask") {
                let task = sut.task(with: request, completionHandler: completionHandler)

                expect(task).to(beAKindOf(URLSessionDataTask.self))
            }
        }
    }
}
