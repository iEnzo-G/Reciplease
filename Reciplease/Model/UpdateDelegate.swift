import Foundation

protocol UpdateDelegate: NSObject {
    func throwAlert(message: String)
    func updateScreen(ingredientText: String)
    func showEmptyMessage(state: Bool)
}
