import Foundation
import Domain

class FetchPokemonDataSpy: FetchPokemonData {
    var pokemonId: Int?
    var completion: ((Result<PokemonModel, DomainError>) -> Void)?

    func getPokemonById(_ id: Int, completion: @escaping (Result<PokemonModel, DomainError>) -> Void) {
        self.pokemonId = id
        self.completion = completion
    }

    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }
}
