import UIKit

class IngredientTableViewCell: UITableViewCell {

    // MARK: - Outlet
    
    @IBOutlet weak var ingredientLabel: UILabel!
    
    // MARK: - Actions
    
    func configure(title: String) {
        ingredientLabel.text = title
    }
}
