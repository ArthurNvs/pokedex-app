import Foundation
import Domain

public final class PokemonFetchPresenter {
    private let alertView: AlertView
    private let fetchPokemonData: FetchPokemonData
    
    public init(alertView: AlertView, fetchPokemonData: FetchPokemonData) {
        self.alertView = alertView
        self.fetchPokemonData = fetchPokemonData
    }
    
    public func getPokemon(id: Int) {
        if let message = validate(id: id) {
            alertView.showMessage(viewModel: AlertViewModel(title: "Pokemon Not Found", message: message))
        } else {
            fetchPokemonData.getPokemonById(id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure: self.alertView.showMessage(viewModel: AlertViewModel(title: "Error", message: "failed!"))
                case .success: self.alertView.showMessage(viewModel: AlertViewModel(title: "Yeah!", message: "success!"))
                }
            }
        }
    }
    
    private func validate(id: Int) -> String? {
        if id == 0 || id > 898 {
            return "It seems you got an invalid ID here!"
        }
        return nil
    }
}
