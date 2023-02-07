import UIKit

class IngredientCell: UITableViewCell {
    
    @IBOutlet weak var ingredientLabel: UILabel!
     
    func configure(title: String) {
        ingredientLabel.text = title
    }
}
