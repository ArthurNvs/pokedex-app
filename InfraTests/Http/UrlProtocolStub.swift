import Foundation

// This is a generic way to intercept any requests and simulate behaviors
class UrlProtocolStub: URLProtocol {
  static var emit: ((URLRequest) -> Void)?
  
  static func observeRequest(completion: @escaping (URLRequest) -> Void) {
    UrlProtocolStub.emit = completion
  }
  
  override open class func canInit(with request: URLRequest) -> Bool {
    return true
  }
  
  override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }
    
  // Execute mocked request
  override open func startLoading() {
    UrlProtocolStub.emit?(request)
  }
      
  override open func stopLoading() {}
}
