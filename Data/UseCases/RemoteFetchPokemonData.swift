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
        //TODO: makeURL()
        //maybe use some vars with the parts of the url and a var that mounts the URL
        httpClient.get(from: url) { result in
            switch result {
            case .success(let data):
                if let model: PokemonModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure: completion(.failure(.unexpected))
            }
        }
    }
}
