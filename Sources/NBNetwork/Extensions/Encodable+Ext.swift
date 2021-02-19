import Foundation

extension Encodable {

    func encodeToData() -> Data? {
        try? JSONEncoder().encode(self)
    }
    
}
