import Foundation

public protocol AlertView {
    func showMessage(viewModel: AlertViewModel)
}

public struct AlertViewModel: Equatable {
    var title: String?
    var message: String?
    
    public init(title: String?, message: String?) {
        self.title = title
        self.message = message
    }
}
