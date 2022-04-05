import XCTest

class RemoteFetchPokemonData {
    private let url: URL
    private let httpClient: HttpGetClient
    
    init(url: URL, httpClient: HttpGetClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    func getOne() {
        httpClient.get(url: url)
    }
}

protocol HttpGetClient {
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

public class HttpClientSpy: HttpGetClient {
    var url: URL?
    
    func get(url: URL) {
        self.url = url
    }
    
}
