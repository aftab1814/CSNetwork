import Foundation

public extension Dictionary where Key == String, Value == String {
    static var empty: [String: String] {
        ["": ""]
    }
    
    func jsonString() -> String? {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

public extension Dictionary where Key == AnyHashable, Value == Any {
    func jsonData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self,
                                           options: .prettyPrinted)
    }
}
