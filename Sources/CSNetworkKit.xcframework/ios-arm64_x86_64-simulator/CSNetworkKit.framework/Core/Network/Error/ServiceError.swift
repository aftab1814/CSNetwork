import Foundation

public enum ServiceError: Error {
    case unknown
    case failed(Int, Data?)
    case noJSONData
    case invalidJSONData
    case typeMismatch(String)
}
