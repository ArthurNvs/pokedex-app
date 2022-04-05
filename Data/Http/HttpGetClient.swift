import Foundation

public protocol HttpGetClient {
    func get(from url: URL, with id: Int)
}
