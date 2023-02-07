import UIKit

class FavoritesRecipesController: UIViewController {
    
    var recipes: [Recipe] = []
    private let coreDataStore = CoreDataStore()
    
    @IBOutlet weak var noRecipesLabel: UILabel!
    @IBOutlet weak var recipesTableView: UITableView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.register(UINib(nibName: "RecipeXibCell", bundle: nil), forCellReuseIdentifier: "RecipeXibCell")
        getRecipes()
        noRecipesLabel.isHidden = recipes.isEmpty ? false : true
    }
    
    // MARK: - Properties
    
    override func viewWillAppear(_ animated: Bool) {
        getRecipes()
        recipesTableView.isAccessibilityElement = true
        recipesTableView.accessibilityValue = "Contains \(recipes.count) recipes displayed"
        recipesTableView.accessibilityHint = "List of your favorites recipes"
        recipesTableView.reloadData()
        noRecipesLabel.isHidden = recipes.isEmpty ? false : true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? RecipeDetailController, let selectedCell = sender as? UITableViewCell else { return }
        guard let selectedIndexPath = recipesTableView.indexPath(for: selectedCell)?.row else { return }
        let currentRecipe = recipes[selectedIndexPath]
        destinationVC.recipe = currentRecipe
    }
    private func getRecipes() {
        recipes = coreDataStore.getRecipes()
    }
}

// MARK: - Extension

extension FavoritesRecipesController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeXibCell", for: indexPath) as? RecipeXibCell else { return UITableViewCell() }
        let currentRecipe = recipes[indexPath.row]
        var image: UIImage?
        imageRequest(image: currentRecipe.image) { data in
            image = UIImage(data: data)
            cell.configure(
                timer: currentRecipe.totalTime.convertTime(),
                image: image,
                calories: currentRecipe.calories.convertCalories())
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "RecipeFavoriteDetail", sender: tableView.cellForRow(at: indexPath))
    }
}

