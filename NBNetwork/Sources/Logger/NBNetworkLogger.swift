import Foundation

enum NBNetworkLogger {

    private enum Line {
        static let header = "--- 🌎 NBNetwork 🌏 ---"
        static let separator = "-----------------------"
        static let request = "--- ⬆️ Request ⬆️ ---"
        static let response = "--- ⬇️ Response ⬇️ ---"
    }

    static func log(request: URLRequest) {
        let url = createLine("URL", with: request.url?.absoluteString)
        let method = createLine("Method", with: request.httpMethod)
        let requestHeader = createLine("Headers", with: request.allHTTPHeaderFields)
        let body = createLine("Body", with: request.httpBody)

        let log = NBNetworkLogger.buildLog([Line.header,
                                            Line.request,
                                            url,
                                            method,
                                            requestHeader,
                                            body,
                                            Line.separator])

        debugPrint(log)
    }

    static func log(data: Data?, response: HTTPURLResponse) {
        let statusCode = createLine("Status Code", with: "\(response.statusCode)")
        let responseData = createLine("Response", with: data)
        let log = NBNetworkLogger.buildLog([Line.response,
                                            statusCode,
                                            responseData,
                                            Line.separator])
        debugPrint(log)
    }

    static func log(error: NBAPIError) {
        let description = createLine("Error", with: error.localizedDescription)
        let log = NBNetworkLogger.buildLog([Line.response,
                                            description,
                                            Line.separator])
        debugPrint(log)
    }

    private static func debugPrint(_ log: NSString) {
        #if DEBUG
            print(log)
        #endif
    }
}

// MARK: - Log Formatter

extension NBNetworkLogger {
    private static func createLine(_ title: String, with value: String?) -> String? {
        guard let value = value else { return nil }
        return "\(title): \(value)"
    }

    private static func createLine(_ title: String, with value: Data?) -> String? {
        guard let value = value,
            let decoded = try? JSONSerialization.jsonObject(with: value),
            let data = try? JSONSerialization.data(withJSONObject: decoded, options: .prettyPrinted),
            let line = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                return nil
        }
        return "\(title): \n\(line)"
    }

    private static func createLine(_ title: String, with value: [String: String]?) -> String? {
        guard let value = value else { return nil }
        var line = String()
        value.forEach { dict in
            line.append("\n  \(dict.key) : \(dict.value)")
        }
        return "\(title): \(line)"
    }

    private static func buildLog(_ messages: [String?]) -> NSString {
        var log = String()

        messages.forEach { message in
            if let message = message {
                log.append(message + "\n")
            }
        }

        return NSString(string: log)
    }
    
}
