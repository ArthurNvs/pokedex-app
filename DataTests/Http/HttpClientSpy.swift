import Foundation
import Data

public class HttpClientSpy: HttpGetClient {
    var urls = [URL]()
    var id: Int?
    var data: Data?
    var completion: ((Result<Data, HttpError>) -> Void)?

    public func get(from url: URL, with id: Int, completion: @escaping (Result<Data, HttpError>) -> Void) {
        self.urls.append(url)
        self.id = id
        self.completion = completion
    }
    
    func completeWithError(_ error: HttpError) {
        completion?(.failure(error))
    }
    
    func completeWithData(_ data: Data) {
        completion?(.success(data))
    }
}
