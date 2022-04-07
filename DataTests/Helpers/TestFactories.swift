import Foundation

func makeInvalidData() -> Data {
    return Data("invalid_json_data".utf8)
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
    return NSError(domain: "any_error", code: 0)
}
