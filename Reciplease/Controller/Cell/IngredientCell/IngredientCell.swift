import UIKit

class IngredientCell: UITableViewCell {
    
    // MARK: - Outlet
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    // MARK: - Actions
    
    func configure(title: String) {
        ingredientLabel.text = title
    }
}
