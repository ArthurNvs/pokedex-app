import Foundation

public struct PokemonModel: Model {
    public var id: Int
    public var name: String
    public var height: Int
    public var weight: Int
//    public var sprites: PokemonSprites
//    public var abilities: [PokemonAbilityData]
    
    public init(id: Int, name: String, height: Int, weight: Int) throws {
        self.id = id
        self.name = name
        self.height = height
        self.weight = weight
//        self.sprites = sprites
//        self.abilities = abilities
    }
}

//public struct PokemonSprites: Model {
//    public var front_default: String
//    public var back_default: String
//}
//
//public struct PokemonAbilityData: Model {
//    public var ability: PokemonAbility
//    public var slot: Int
//}
//
//public struct PokemonAbility: Model {
//    public var name: String
//    public var url: String
//}
