import UIKit

class FavoritesRecipesController: UIViewController {
    
    private var recipes: [Hit] = []
    private let coreDataStack = CoreDataStack()
    
    @IBOutlet weak var noRecipesLabel: UILabel!
    @IBOutlet weak var recipesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.register(UINib(nibName: "RecipeXibCell", bundle: nil), forCellReuseIdentifier: "RecipeXibCell")
        getRecipes()
        noRecipesLabel.isHidden = recipes.isEmpty ? false : true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRecipes()
        recipesTableView.reloadData()
        noRecipesLabel.isHidden = recipes.isEmpty ? false : true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? RecipeDetailController, let selectedCell = sender as? UITableViewCell else { return }
        guard let selectedIndexPath = recipesTableView.indexPath(for: selectedCell)?.row else { return }
        let currentRecipe = recipes[selectedIndexPath]
        destinationVC.recipes.append(currentRecipe)
    }
    
    private func getRecipes() {
        let recipesFromCoreData = coreDataStack.getRecipes()
        recipes = recipesFromCoreData.map { recipe in
            let hits = Hit(recipe: recipe)
            return hits
        }
    }
}

extension FavoritesRecipesController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeXibCell", for: indexPath) as? RecipeXibCell else { return UITableViewCell() }
        let currentRecipe = recipes[indexPath.row].recipe
        var image: UIImage?
        imageRequest(image: currentRecipe.image) { data in
            image = UIImage(data: data)
            cell.configure(
                timer: self.convertTime(time: currentRecipe.totalTime),
                image: image,
                calories: self.convertCalories(calories: currentRecipe.calories))
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

