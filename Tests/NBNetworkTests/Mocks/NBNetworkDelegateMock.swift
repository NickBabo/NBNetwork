import Foundation
import NBNetwork

class NBNetworkDelegateMock: NBNetworkDelegate {

    func getToken() -> String? {
        "token_mock"
    }
}
