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
    
    func test_getPokemonById_should_complete_with_pokemon_if_client_completes_with_data() {
        let (sut, httpClientSpy) = makeSut()
        let exp = expectation(description: "waiting")
        let expectedPokemon = makePokemonModel()
        sut.getPokemonById(0) { result in
            switch result {
            case .success(let receivedPokemon): XCTAssertEqual(receivedPokemon, expectedPokemon)
            case.failure: XCTFail("Expected error, received \(result) instead")
            }
            exp.fulfill()
        }
        httpClientSpy.completeWithData(makePokemonModel().toData()!)
        wait(for: [exp], timeout: 1)
    }
}

extension RemoteFetchPokemonDataTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteFetchPokemonData, httpClient: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPokemonData(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    func makePokemonModel() -> PokemonModel {
        return PokemonModel(id: 0, name: "Bubasaur", baseExperience: 10, height: 10, weight: 10, isDefault: true, order: 1)
    }
    
    public class HttpClientSpy: HttpGetClient {
        var urls = [URL]()
        var id: Int?
        var data: Data?
        var completion: ((Result<Data, HttpError>) -> Void)?

        func get(from url: URL, with id: Int, completion: @escaping (Result<Data, HttpError>) -> Void) {
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
}
