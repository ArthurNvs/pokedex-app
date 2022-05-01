import Foundation
import Domain

class FetchPokemonDataSpy: FetchPokemonData {
    var pokemonId: Int?
    var completion: ((FetchPokemonData.Result) -> Void)?

    func getPokemonById(_ id: Int, completion: @escaping (FetchPokemonData.Result) -> Void) {
        self.pokemonId = id
    }

    func completeWithPokemon(_ pokemon: PokemonModel) {
        completion?(.success(pokemon))
    }

    func completeWithError(_ error: DomainError) {
        completion?(.failure(error))
    }
}
