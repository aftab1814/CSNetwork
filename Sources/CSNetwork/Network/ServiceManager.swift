import Foundation

protocol JSONParseable {
    func parse<T: Decodable>(data: Data) throws -> T?
}

final class ServiceManager: NSObject {

    private var session: ServiceSessionProtocol
    private var task: URLSessionDataTaskProtocol?
    
    init(session: ServiceSessionProtocol = URLSession.shared) {
        self.session = session
    }
 
    private func handleDataResponse<T: Decodable>(data: Data?, response: HTTPURLResponse?, error: Error?, completion: (ServiceResponse<T>) -> Void) {
        guard error == nil else { return completion(.failure(error!)) }
        
        guard let response = response else { return completion(.failure(ServiceError.noJSONData)) }
        
        switch response.statusCode {
        case 200...299:
            guard let data = data else {
                return completion(.failure(ServiceError.noJSONData))
            }
            
            do {
                if T.Type.self == Data.Type.self,
                   let data = data as? T {
                    return completion(.success(data))
                }
                let model = try JSONDecoder().decode(T.self, from: data)
                completion(.success(model))
            } catch DecodingError.dataCorrupted {
                return completion(.failure(ServiceError.invalidJSONData))
            } catch DecodingError.typeMismatch(_, let context) {
                return completion(.failure(ServiceError.typeMismatch(context.debugDescription)))
            } catch {
                return completion(.failure(ServiceError.unknown))
            }

        default:
            completion(.failure(ServiceError.failed(response.statusCode, data)))
        }
    }
}

extension ServiceManager: ServiceProviderProtocol {
    func request<T>(type: T.Type, service: ServiceProtocol, completion: @escaping (ServiceResponse<T>) -> Void) where T: Decodable {
        let request = URLRequest(service: service)
        self.task = self.session.dataTask(request: request, completionHandler: { [weak self] data, response, error in
            let httpResponse = response as? HTTPURLResponse
            self?.handleDataResponse(data: data, response: httpResponse, error: error, completion: completion)
        })
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
}
