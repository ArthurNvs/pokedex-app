import Foundation
import Domain

public final class RemoteFetchPokemonData: FetchPokemonData {
    private let url: URL
    private let httpClient: HttpGetClient
    
    public init(url: URL, httpClient: HttpGetClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func getPokemonById(_ id: Int, completion: @escaping (Result<PokemonModel, DomainError>) -> Void) {
        httpClient.get(from: url, with: id) { result in
            switch result {
            case .success(let data):
                if let model: PokemonModel = data.toModel() {
                    completion(.success(model))
                }
            case .failure: completion(.failure(.unexpected))
            }
        }
    }
}
