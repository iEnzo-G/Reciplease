import UIKit

class RecipeXibCell: UITableViewCell {
    
    @IBOutlet weak var caloriesTextField: UITextField!
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var recipeImageView: UIImageView!
    
    func configure(timer: String, image: UIImage?, calories: String) {
        timerTextField.text = timer
        recipeImageView.image = image
        caloriesTextField.text = calories
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor(red: 48/255, green: 79/255, blue: 102/255, alpha: 1.0).cgColor
    }
}
