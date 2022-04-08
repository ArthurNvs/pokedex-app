import Foundation

func makeInvalidData() -> Data {
    Data("invalid_json_data".utf8)
}

func makeValidData() -> Data {
  Data("{\"name\":\"Pikachu\"}".utf8)
}

func makeEmptyData() -> Data {
  Data()
}

func makeHttpResponse(statusCode: Int = 200) -> HTTPURLResponse {
    HTTPURLResponse(url: makeUrl(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
}

func makeUrl() -> URL {
    let id = 1
    var components = URLComponents()
    components.scheme = "http"
    components.host = "any-url.com"
    components.path = "/\(id)"
    return components.url!
}

func makeError() -> Error {
    NSError(domain: "any_error", code: 0)
}
