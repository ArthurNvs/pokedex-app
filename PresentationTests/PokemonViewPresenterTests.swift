import XCTest

class PokemonViewPresenter {
    private let alertView: AlertView
    
    init(alertView: AlertView) {
        self.alertView = alertView
    }
    
    func getPokemon(id: Int) {
        if let message = validate(id: id) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Pokemon Not Found", message: message))
        }
    }
    
    private func validate(id: Int) -> String? {
        if id == 0 || id > 898 {
            return "It seems you got an invalid ID here!"
        }
        return nil
    }
}

protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

struct AlertViewModel: Equatable {
    var title: String
    var message: String
}

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
