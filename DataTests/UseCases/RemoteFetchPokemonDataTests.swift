import XCTest
import Domain
import Data

class RemoteFetchPokemonDataTests: XCTestCase {
    func test_getOne_should_call_httpClient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.getPokemonById(1) { _ in }
        XCTAssertEqual(httpClientSpy.urls, [url])
    }
    
    func test_getPokemonById_should_call_httpClient_with_correct_id() {
        let (sut, httpClientSpy) = makeSut()
        let id = 1
        sut.getPokemonById(id) { _ in }
        XCTAssertEqual(httpClientSpy.id, id)
    }
    
    func test_getPokemonById_should_complete_with_error_if_client_completes_with_error() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        sut.getPokemonById(0) { result in
            switch result {
            case.failure(let error): XCTAssertEqual(error, .unexpected)
            case .success: XCTFail("Expected error, received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithError(.noConnectivity)
        wait(for: [exp], timeout: 1)
    }
}

extension RemoteFetchPokemonDataTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteFetchPokemonData, httpClient: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPokemonData(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    public class HttpClientSpy: HttpGetClient {
        var urls = [URL]()
        var id: Int?
        var completion: ((Result<Data, HttpError>) -> Void)?

        func get(from url: URL, with id: Int, completion: @escaping (Result<Data, HttpError>) -> Void) {
            self.urls.append(url)
            self.id = id
            self.completion = completion
        }
        
        func completeWithError(_ error: HttpError) {
            completion?(.failure(error))
        }
    }
}
