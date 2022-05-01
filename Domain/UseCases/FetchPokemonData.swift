import Foundation

public protocol FetchPokemonData {
    typealias Result = Swift.Result<PokemonModel, DomainError>
    func getPokemonById(_ id: Int, completion: @escaping (Result) -> Void)
}
