import Foundation

final class IngredientsStore {
    
    // MARK: - Properties
    
    var ingredients: [String] = []
    weak var delegate: UpdateDelegate?
    var ingredientText: String = "" {
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
        guard !ingredients.contains(ingredient) else {
            delegate?.throwAlert(message: "You have already add this ingredient.")
            return
        }
        ingredients.append(ingredient)
        delegate?.showEmptyMessage(state: false)
        delegate?.updateScreen(ingredientText: "")
    }
    
    func searchRecipe() {
        guard !ingredients.isEmpty else {
            delegate?.throwAlert(message: "You must add at least one ingredient first.")
            return
        }
    }
    
    func clearList() {
        ingredients.removeAll()
        delegate?.showEmptyMessage(state: true)
    }
}
