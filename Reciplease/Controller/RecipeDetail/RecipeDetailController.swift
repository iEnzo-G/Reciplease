import UIKit
import CoreData

class RecipeDetailController: UIViewController {
    
    var recipes: [Hit] = []
    let coreDataStack = CoreDataStack()
    
    // MARK: - Outlet
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var calorieTextField: UITextField!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var moreDetailButton: UIButton!
    @IBOutlet weak var ingredientDetailTableView: UITableView!
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFavoriteButton()
        
        let currentRecipe = recipes[0].recipe
        timerTextField.text = currentRecipe.totalTime.convertTime()
        calorieTextField.text = currentRecipe.calories.convertCalories()
        imageRequest(image: currentRecipe.image) { imageData in
            self.recipeImageView.image = UIImage(data: imageData)
        }
    }
    
    @IBAction func tappedFavoriteButton(_ sender: UIButton) {
        let currentRecipe = recipes[0].recipe
        coreDataStack.checkRecipeExists(url: currentRecipe.url) == false ? coreDataStack.saveRecipe(currentRecipe) : coreDataStack.deleteRecipe(currentRecipe)
        updateFavoriteButton()
    }
    
    @IBAction func tappedMoreDetailButton(_ sender: UIButton) {
        guard let url = URL(string: recipes[0].recipe.url) else { return }
        UIApplication.shared.open(url)
    }
    
    func updateFavoriteButton() {
        let currentRecipe = recipes[0].recipe
        favoriteButton.tintColor = coreDataStack.checkRecipeExists(url: currentRecipe.url) == true ? .systemGreen : .systemRed
    }
    
    
}

// MARK: - Extension

extension RecipeDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes[0].recipe.ingredientLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientDetailCell", for: indexPath)
        let currentIngredient = recipes[0].recipe.ingredientLines[indexPath.row]
        cell.textLabel?.text = currentIngredient
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
