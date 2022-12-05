import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public typealias Headers = [String: String]
public typealias Parameters = [AnyHashable: Any]
public typealias QueryItems = [String: String]

public protocol ServiceProtocol {
    var baseURL: URL { get }
    // var endpointURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: Headers? { get }
    var parameters: Parameters? { get }
    var queryItems: QueryItems? { get }
    var isUserLoggedIn: Bool { get }
    var additionalHeaders: Headers? { get }
}

extension URLRequest {
    public init(service: ServiceProtocol) {
        let url = service.baseURL.appendingPathComponent(service.path)
        var components = URLComponents(string: url.absoluteString)
        components?.queryItems = service.queryItems?.map({ (key, value) in
            URLQueryItem(name: key, value: value)
        })
        self.init(url: components?.url ?? url)
        self.httpMethod = service.method.rawValue
        service.headers?.forEach { key, value in
            self.addValue(value, forHTTPHeaderField: key)
        }
        service.additionalHeaders?.forEach { key, value in
            guard !value.isEmpty else { return }
            self.addValue(value, forHTTPHeaderField: key)
        }
        
        switch service.method {
            
        case .get:
            break
            
        case .post, .put, .delete:
            if let jsonData = service.parameters?.jsonData() {
                self.httpBody = jsonData
            }
        }
    }
}


extension Dictionary where Key == AnyHashable, Value == Any {
    public func jsonData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self,
                                           options: .prettyPrinted)
    }
}
