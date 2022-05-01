import XCTest
import Presentation
import Domain

class PokemonViewPresenterTests: XCTestCase {
    func test_getPokemon_should_show_error_if_id_is_not_valid() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Pokemon Not Found", message: "It seems you got an invalid ID here!"))
            exp.fulfill()
        }
        sut.getPokemon(id: 0)
        wait(for: [exp], timeout: 1)
    }
    
    func test_getPokemon_should_show_generic_error_message_if_fetchPokemonData_fails() {
        let alertViewSpy = AlertViewSpy()
        let fetchPokemonDataSpy = FetchPokemonDataSpy()
        let sut = makeSut(alertView: alertViewSpy, fetchPokemonDataSpy: fetchPokemonDataSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, self.makeErrorAlertViewModel(message: "failed!"))
            exp.fulfill()
        }
        sut.getPokemon(id: 1)
        fetchPokemonDataSpy.completeWithError(.unexpected)
        wait(for: [exp], timeout: 1)
    }
    
    func test_getPokemon_should_call_fetchPokemonData_with_correct_id() {
        let fetchPokemonDataSpy = FetchPokemonDataSpy()
        let sut = makeSut(fetchPokemonDataSpy: fetchPokemonDataSpy)
        sut.getPokemon(id: 1)
        XCTAssertEqual(fetchPokemonDataSpy.pokemonId, 1)
    }
    
    func test_signup_should_show_success_message_if_fetchPokemonData_succeeds() {
        let alertViewSpy = AlertViewSpy()
        let fetchPokemonDataSpy = FetchPokemonDataSpy()
        let sut = makeSut(alertView: alertViewSpy, fetchPokemonDataSpy: fetchPokemonDataSpy)
        let exp = expectation(description: "waiting")
        alertViewSpy.observe { viewModel in
            XCTAssertEqual(viewModel, AlertViewModel(title: "Yeah!", message: "success!"))
            exp.fulfill()
        }
        sut.getPokemon(id: 1)
        fetchPokemonDataSpy.completeWithPokemon(makePokemonModel()!)
        wait(for: [exp], timeout: 1)
    }
}

extension PokemonViewPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy(), fetchPokemonDataSpy: FetchPokemonDataSpy = FetchPokemonDataSpy(), file: StaticString = #filePath, line: UInt = #line) -> PokemonFetchPresenter {
        let sut = PokemonFetchPresenter(alertView: alertView, fetchPokemonData: fetchPokemonDataSpy)
        checkMemoryLeak(for: sut, file: file, line: line)
        return sut
    }
    
    func makeErrorAlertViewModel(message: String) -> AlertViewModel {
        AlertViewModel(title: "Error", message: message)
    }
            
    func makePokemonModel() -> PokemonModel? {
        do {
            let pokemon = try PokemonModel(id: 1, name: "Bubasaur", height: 30, weight: 30)
            return pokemon
        } catch {
            print(error)
        }
        return nil
    }
}
