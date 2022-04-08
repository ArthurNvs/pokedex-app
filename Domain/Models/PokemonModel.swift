import Foundation

public struct PokemonModel: Model {
    public var id: Int
    public var name: String
    public var height: Int
    public var weight: Int
    public var sprites: PokemonSprites
    
    public init(id: Int, name: String, height: Int, weight: Int, sprites: PokemonSprites) throws {
        self.id = id
        self.name = name
        self.height = height
        self.weight = weight
        self.sprites = sprites
    }
}

public struct PokemonSprites: Model {
    public var front_default: String
    public var back_default: String
}
