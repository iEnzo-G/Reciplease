import UIKit
import CoreData

class RecipeDetailController: UIViewController {
    
    private let coreDataStore = CoreDataStore()
    var recipe = Recipe(label: "", image: "", url: "", ingredientLines: [""], calories: 0, totalTime: 0)
    
    // MARK: - Outlet
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var calorieTextField: UITextField!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var timerTextField: UITextField!
    @IBOutlet weak var moreDetailButton: UIButton!
    @IBOutlet weak var ingredientDetailTableView: UITableView!
    
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFavoriteButton()
        ingredientDetailTableView.isAccessibilityElement = true
        ingredientDetailTableView.accessibilityTraits = .staticText
        ingredientDetailTableView.accessibilityValue = 	recipe.ingredientLines.joined(separator: " ,")
        ingredientDetailTableView.accessibilityHint = "List of ingredients you need to make the recipe"
        recipeNameLabel.text = recipe.label
        timerTextField.text = recipe.totalTime.convertTime()
        calorieTextField.text = recipe.calories.convertCalories()
        imageRequest(image: recipe.image) { [weak self] imageData in
            self?.recipeImageView.image = UIImage(data: imageData)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateFavoriteButton()
    }
    
    // MARK: - Actions
    
    @IBAction func tappedFavoriteButton(_ sender: UIButton) {
        coreDataStore.checkRecipeExists(url: recipe.url) == false ? coreDataStore.saveRecipe(recipe) : coreDataStore.deleteRecipe(recipe)
        updateFavoriteButton()
    }
    
    @IBAction func tappedMoreDetailButton(_ sender: UIButton) {
        guard let url = URL(string: recipe.url) else { return }
        UIApplication.shared.open(url)
    }
    
    func updateFavoriteButton() {
        favoriteButton.tintColor = coreDataStore.checkRecipeExists(url: recipe.url) == true ? .systemGreen : .systemRed
    }
}

// MARK: - Extension

extension RecipeDetailController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.ingredientLines.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientDetailCell", for: indexPath)
        let currentIngredient = recipe.ingredientLines[indexPath.row]
        cell.textLabel?.text = currentIngredient
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
