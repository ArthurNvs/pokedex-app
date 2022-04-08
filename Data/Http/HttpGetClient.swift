import Foundation

public protocol HttpGetClient {
    func get(from url: URL, completion: @escaping (Result<Data?, HttpError>) -> Void)
}
