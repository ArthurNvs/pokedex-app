import Foundation

public protocol FetchPokemonData {
    func getPokemonById(_ id: Int, completion: @escaping (Result<PokemonModel, Error>) -> Void)
}

public struct PokemonModel {
    var id: Int
    var name: String
    var baseExperience: Int
    var height: Int
    var weight: Int
    var isDefault: Bool
    var order: Int
}
