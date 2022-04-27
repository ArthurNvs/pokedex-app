import XCTest
import Presentation

class PokemonViewPresenterTests: XCTestCase {
    func test_getPokemon_should_show_error_if_id_is_not_valid() {
        let alertViewSpy = AlertViewSpy()
        let sut = makeSut(alertView: alertViewSpy)
        sut.getPokemon(id: 0)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Pokemon Not Found", message: "It seems you got an invalid ID here!"))
    }
    
    func test_getPokemon_should_return_pokemon_with_valid_id() {
        let sut = makeSut()
        sut.getPokemon(id: 1)
    }
}

extension PokemonViewPresenterTests {
    func makeSut(alertView: AlertViewSpy = AlertViewSpy()) -> PokemonViewPresenter {
        let sut = PokemonViewPresenter(alertView: alertView)
        return sut
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
