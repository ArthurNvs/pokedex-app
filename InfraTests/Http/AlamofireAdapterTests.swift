import XCTest
import Alamofire
import Data

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func get(from url: URL, completion: @escaping (Result<Data, HttpError>) -> Void) {
        session.request(url, method: .get).responseData { dataResponse in
            guard dataResponse.response?.statusCode != nil else { return completion(.failure(.noConnectivity)) }
            switch dataResponse.result {
            case .failure: completion(.failure(.noConnectivity))
            case .success(let data): completion(.success(data))
            }
        }
    }
}

class AlamofireAdapterTests: XCTestCase {
    func test_get_should_make_request_with_valid_url_and_method() {
        let url = makeUrl()
        testRequestFor(url: url) { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("GET", request.httpMethod)
        }
    }
    
    func test_get_should_complete_with_data_when_request_completes_with_status_200() {
        expectResult(.success(makeValidData()), when: (makeValidData(), makeHttpResponse(), nil))
    }
    
    func test_get_should_complete_with_error_when_request_completes_with_error() {
        expectResult(.failure(.noConnectivity), when: (nil, nil, makeError()))
    }
    
    func test_get_should_complete_with_error_on_all_invalid_cases() {
        expectResult(.failure(.noConnectivity), when: (makeValidData(), makeHttpResponse(), makeError()))
        expectResult(.failure(.noConnectivity), when: (nil, makeHttpResponse(), makeError()))
        expectResult(.failure(.noConnectivity), when: (makeValidData(), nil, makeError()))
        expectResult(.failure(.noConnectivity), when: (nil, makeHttpResponse(), nil))
        expectResult(.failure(.noConnectivity), when: (makeValidData(), nil, nil))
        expectResult(.failure(.noConnectivity), when: (nil, nil, nil))
    }
}

extension AlamofireAdapterTests {
    func makeSut(file: StaticString = #filePath, line: UInt = #line) -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        let sut = AlamofireAdapter(session: session)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func testRequestFor(url: URL, action: @escaping (URLRequest) -> Void) {
        let sut = makeSut()
        let exp = expectation(description: "waiting")
        sut.get(from: url) { _ in exp.fulfill() }
        var request: URLRequest?
        UrlProtocolStub.observeRequest { request = $0 }
        wait(for: [exp], timeout: 1)
        action(request!)
    }
    
    func expectResult(_ expectedResult: Result<Data, HttpError>,
                      when stub: (data: Data?, response: HTTPURLResponse?, error: Error?),
                      file: StaticString = #filePath, line: UInt = #line) {
        let sut = makeSut()
        UrlProtocolStub.simulate(data: stub.data, response: stub.response, error: stub.error)
        let exp = expectation(description: "waiting")
        sut.get(from: makeUrl()) { receivedResult in
            switch (receivedResult, expectedResult ) {
            case (.failure(let expectedError), .failure(let receivedError)):
                XCTAssertEqual(expectedError, receivedError, file: file, line: line)
            case (.success(let expectedData), .success(let receivedData)):
                XCTAssertEqual(expectedData, receivedData, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult) but got \(receivedResult) instead")
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)
    }
}
