import XCTest
import Data
import Infra

class FetchPokemonDataIntegrationTests: XCTestCase {
    func test_fetch_pokemon_data() {
        let alamofireAdapter = AlamofireAdapter()
        let pokemonId = 1
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonId)")!
        let sut = RemoteFetchPokemonData(url: url, httpClient: alamofireAdapter)
        let exp = expectation(description: "waiting")
        sut.getPokemonById(pokemonId) { result in
            switch result {
            case .failure: XCTFail("Expect succes but got \(result) instead")
            case .success(let pokemonData):
                XCTAssertNotNil(pokemonData)
                XCTAssertEqual(pokemonData.id, pokemonId)
                XCTAssertNotNil(pokemonData.name)
                XCTAssertNotNil(pokemonData.height)
                XCTAssertNotNil(pokemonData.weight)
                XCTAssertNotNil(pokemonData.sprites.front_default)
                XCTAssertNotNil(pokemonData.sprites.back_default)
                XCTAssertNotNil(pokemonData.abilities)
            }
            exp.fulfill()
        }
        wait(for: [exp], timeout: 5)
    }
}
