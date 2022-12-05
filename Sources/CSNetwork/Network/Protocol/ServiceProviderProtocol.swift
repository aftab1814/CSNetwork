import Foundation

public enum ServiceResponse<T> {
    case success(T)
    case failure(Error)
}

public protocol ServiceProviderProtocol {
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping(ServiceResponse<T>) -> Void) where T: Decodable
    func cancel()
}
