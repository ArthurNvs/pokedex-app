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
        httpClient.get(url: url, id: id)
    }
}

protocol HttpGetClient {
    func get(url: URL, id: Int)
}

class RemoteFetchPokemonDataTests: XCTestCase {
    func test_getOne_should_call_httpClient_with_correct_url() {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPokemonData(url: url, httpClient: httpClientSpy)
        sut.getPokemonById(1)
        XCTAssertEqual(httpClientSpy.url, url)
    }
    
    func test_getPokemonById_should_call_httpClient_with_correct_id() {
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPokemonData(url: URL(string: "http://any-url.com")!, httpClient: httpClientSpy)
        sut.getPokemonById(1)
        XCTAssertEqual(httpClientSpy.id, 1)
    }
}

extension RemoteFetchPokemonDataTests {
    public class HttpClientSpy: HttpGetClient {
        var url: URL?
        var id: Int?
        
        func get(url: URL, id: Int) {
            self.url = url
            self.id = id
        }
    }
}
