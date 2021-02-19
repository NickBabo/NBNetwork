import Foundation

enum NBLocalized {

    private static let bundle: Bundle = Bundle(for: NBNetwork.self)

    static func string(_ localized: LocalizedString) -> String {
        NSLocalizedString(localized.rawValue,
                          bundle: bundle,
                          comment: "")
    }

    static func formatted(string: LocalizedString, arguments: [String]) -> String {
        String(format: NBLocalized.string(string), arguments: arguments)
    }
    
}

enum LocalizedString: String {

    case noResponseDescription
    case noDataDescription
    case decodingErrorDescription
    case invalidBaseURLDescription
    case statusCodeErrorDescription

}
