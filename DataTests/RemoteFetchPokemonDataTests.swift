import XCTest

class RemoteFetchPokemonData {
    private let url: URL
    private let httpClient: HttpClient
    
    init(url: URL, httpClient: HttpClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func getOne() {
        httpClient.get(url: url)
    }
}

protocol HttpClient {
    func get(url: URL)
}

class RemoteFetchPokemonDataTests: XCTestCase {
    func test() {
        let url = URL(string: "http://any-url.com")!
        let httpClientSpy = HttpClientSpy()
        let sut = RemoteFetchPokemonData(url: url, httpClient: httpClientSpy)
        sut.getOne()
        XCTAssertEqual(httpClientSpy.url, url)
    }
}

public class HttpClientSpy: HttpClient {
    var url: URL?
    
    func get(url: URL) {
        self.url = url
    }
    
}
