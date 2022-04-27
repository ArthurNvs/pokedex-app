import XCTest
import Presentation

class PokemonViewPresenterTests: XCTestCase {
    func test_getPokemon_should_show_error_if_id_is_not_valid() {
        let (sut, alertViewSpy) = makeSut()
        sut.getPokemon(id: 0)
        XCTAssertEqual(alertViewSpy.viewModel, AlertViewModel(title: "Pokemon Not Found", message: "It seems you got an invalid ID here!"))
    }
}

extension PokemonViewPresenterTests {
    func makeSut() -> (sut: PokemonViewPresenter, alertView: AlertViewSpy) {
        let alertViewSpy = AlertViewSpy()
        let sut = PokemonViewPresenter(alertView: alertViewSpy)
        return (sut, alertViewSpy)
    }
    
    class AlertViewSpy: AlertView {
        var viewModel: AlertViewModel?
        
        func showMessage(viewModel: AlertViewModel) {
            self.viewModel = viewModel
        }
    }
}
