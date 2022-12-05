import Foundation

enum ServiceResponse<T> {
    case success(T)
    case failure(Error)
}

protocol ServiceProviderProtocol {
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping(ServiceResponse<T>) -> Void) where T: Decodable
    func cancel()
}
