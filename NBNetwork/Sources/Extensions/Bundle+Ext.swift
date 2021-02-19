import Foundation

extension Bundle {

    enum BundleInfoKey: String {
        case baseURL = "NB_BASE_URL"
    }

    func getInfo<T>(for key: BundleInfoKey) -> T? {
        self.infoDictionary?[key.rawValue] as? T
    }
    
}
