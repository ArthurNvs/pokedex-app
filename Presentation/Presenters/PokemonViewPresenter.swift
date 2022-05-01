import Foundation
import Domain

public final class PokemonViewPresenter {
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
            fetchPokemonData.getPokemonById(id) { result in
                switch result {
                case .failure: self.alertView.showMessage(viewModel: AlertViewModel(title: "Error", message: "failed!"))
                case .success: break
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
