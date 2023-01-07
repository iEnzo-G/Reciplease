import Foundation

final class Ingredient {
    
    // MARK: - Properties
    
    var list: [String] = []
    weak var delegate: UpdateDelegate?
    private var ingredientText: String = "" {
        didSet {
            delegate?.updateScreen(ingredientText: ingredientText)
        }
    }
    
    // MARK: - Functions
    
    func addIngredient(_ ingredient: String) {
        guard ingredient != "" else {
            delegate?.throwAlert(message: "You must first specify a new ingredient.")
            return
        }
        guard !list.contains(ingredient) else {
            delegate?.throwAlert(message: "You have already add this ingredient.")
            return
        }
        list.append(ingredient)
        delegate?.showEmptyMessage(state: false)
        delegate?.updateScreen(ingredientText: "")
    }
    
    func searchRecipe() {
        guard !list.isEmpty else {
            delegate?.throwAlert(message: "You must add at least one ingredient first.")
            return
        }
    }
    
    func clearList() {
        list.removeAll()
        delegate?.showEmptyMessage(state: true)
    }
}
