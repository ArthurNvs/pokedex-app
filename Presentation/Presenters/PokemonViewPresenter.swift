import Foundation

public final class PokemonViewPresenter {
    private let alertView: AlertView
    
    public init(alertView: AlertView) {
        self.alertView = alertView
    }
    
    public func getPokemon(id: Int) {
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
