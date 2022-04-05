import XCTest
import Domain
import Data

class RemoteFetchPokemonDataTests: XCTestCase {
    func test_getOne_should_call_httpClient_with_correct_url() {
        let url = makeUrl()
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
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithError(.noConnectivity)
        })
    }
    
    func test_getPokemonById_should_complete_with_pokemon_if_client_completes_with_valid_data() {
        let (sut, httpClientSpy) = makeSut()
        let pokemon = makePokemonModel()
        expect(sut, completeWith: .success(pokemon), when: {
            httpClientSpy.completeWithData(makePokemonModel().toData()!)
        })
    }
    
    func test_getPokemonById_should_complete_with_error_if_client_completes_with_invalid_data() {
        let (sut, httpClientSpy) = makeSut()
        expect(sut, completeWith: .failure(.unexpected), when: {
            httpClientSpy.completeWithData(makeInvalidData())
        })
    }
}

extension RemoteFetchPokemonDataTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteFetchPokemonData, httpClient: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPokemonData(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    func expect(_ sut: RemoteFetchPokemonData,
                completeWith expectedResult: Result<PokemonModel, DomainError>,
                when action: () -> Void,
                file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "waiting")
        sut.getPokemonById(0) { receivedResult in
            switch (expectedResult, receivedResult) {
            case(.failure(let expectedError), .failure(let receivedError)): XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case(.success(let expectedPokemon), .success(let receivedPokemon)): XCTAssertEqual(expectedPokemon, receivedPokemon, file: file, line: line)
            default: XCTFail("Expected \(expectedResult) received \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        action()
        wait(for: [exp], timeout: 1)
    }
    
    func makeInvalidData() -> Data {
        return Data("invalid_json_data".utf8)
    }
    
    func makeUrl() -> URL {
        return URL(string: "http://any-url.com")!
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
