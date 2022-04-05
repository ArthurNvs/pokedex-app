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
    func makeSut(url: URL = URL(string: "http://any-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteFetchPokemonData, httpClient: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPokemonData(url: url, httpClient: httpClientSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        checkMemoryLeak(for: httpClientSpy, file: file, line: line)
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
}
