import Foundation

public protocol FetchPokemonData {
    func getPokemonById(_ id: Int, completion: @escaping (Result<PokemonModel, Error>) -> Void)
}
