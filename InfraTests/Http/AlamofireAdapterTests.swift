import XCTest
import Alamofire

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func get(from url: URL) {
        session.request(url, method: .get).resume()
    }
}

class AlamofireAdapterTests: XCTestCase {
    func test_alamofire() {
        let url = makeUrl()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = makeSut(session: session)
        sut.get(from: url)
        let exp = expectation(description: "waiting")
        UrlProtocolStub.observeRequest { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("GET", request.httpMethod)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}

extension AlamofireAdapterTests {
    func makeSut(session: Session) -> AlamofireAdapter {
        return AlamofireAdapter(session: session)
    }
}
