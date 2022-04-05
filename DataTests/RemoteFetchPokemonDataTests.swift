import XCTest
import Domain

class RemoteFetchPokemonData {
    private let url: URL
    private let httpClient: HttpGetClient
    
    init(url: URL, httpClient: HttpGetClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func getPokemonById(_ id: Int) {
        httpClient.get(from: url, with: id)
    }
}

protocol HttpGetClient {
    func get(from url: URL, with id: Int)
}

class RemoteFetchPokemonDataTests: XCTestCase {
    func test_getOne_should_call_httpClient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let (sut, httpClientSpy) = makeSut(url: url)
        sut.getPokemonById(1)
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_getPokemonById_should_call_httpClient_with_correct_id() {
        let (sut, httpClientSpy) = makeSut()
        let id = 1
        sut.getPokemonById(id)
        XCTAssertEqual(httpClientSpy.id, id)
    }
}

extension RemoteFetchPokemonDataTests {
    func makeSut(url: URL = URL(string: "http://any-url.com")!) -> (sut: RemoteFetchPokemonData, httpClient: HttpClientSpy) {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPokemonData(url: url, httpClient: httpClientSpy)
        return (sut, httpClientSpy)
    }
    
    public class HttpClientSpy: HttpGetClient {
        var url: URL?
        var id: Int?
        
        func get(from url: URL, with id: Int) {
            self.url = url
            self.id = id
        }
    }
}
