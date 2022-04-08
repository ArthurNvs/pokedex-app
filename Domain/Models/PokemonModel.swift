import Foundation

public struct PokemonModel: Model {
    public var id: Int
//    public var name: String
//    public var baseExperience: Int
//    public var height: Int
    public var weight: Int
//    public var isDefault: Bool
//    public var order: Int
    
//    public init(id: Int, name: String, baseExperience: Int, height: Int, weight: Int, isDefault: Bool, order: Int) {
//        self.id = id
//        self.name = name
//        self.baseExperience = baseExperience
//        self.height = height
//        self.weight = weight
//        self.isDefault = isDefault
//        self.order = order
//    }
    
    public init(id: Int, weight: Int) throws {
        self.id = id
        self.weight = weight
    }
}
