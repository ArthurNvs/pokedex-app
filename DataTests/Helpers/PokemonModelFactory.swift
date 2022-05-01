import Foundation
import Domain

func makePokemonModel() -> PokemonModel? {
    do {
        let pokemon = try PokemonModel(id: 1, name: "Bubasaur", height: 30, weight: 30)
        return pokemon
    } catch {
        print(error)
    }
    return nil
}
