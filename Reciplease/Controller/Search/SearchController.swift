import UIKit

class SearchController: UIViewController {
    
    // MARK: - Properties
    
    private var recipes: [Hit] = []
    private var nextPage: Next = .init(href: "")
    private let ingredient = IngredientsStore()
    private let service = RecipeService()
    
    // MARK: - Outlets
    
    @IBOutlet weak var noIngredientLabel: UILabel!
    @IBOutlet weak var searchRecipeButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientTableView.isAccessibilityElement = true
        ingredientTableView.accessibilityValue = "List of ingredient added available in your fridge"
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        ingredient.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    
    // MARK: - Actions
    
    @IBAction func tappedClearButton(_ sender: UIButton) {
        ingredient.clearList()
        ingredientTableView.reloadData()
    }
    
    @IBAction func tappedAddButton(_ sender: UIButton) {
        guard let ingredientText = searchTextField.text else { return }
        ingredient.addIngredient(ingredientText)
        ingredientTableView.reloadData()
    }
    
    @IBAction func tappedSearchRecipeButton(_ sender: UIButton) {
        ingredient.searchRecipe()
        searchRecipeButton.isHidden = true
        activityIndicator.startAnimating()
        recipeRequest()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? RecipesController else { return }
        destinationVC.recipes = recipes
        destinationVC.nextPage = nextPage
    }
    
    private func recipeRequest() {
        service.request(ingredientList: ingredient.ingredients) { [weak self] result in
            switch result {
            case let .success(item):
                self?.nextPage = item._links.next
                self?.recipes = item.hits
                self?.activityIndicator.stopAnimating()
                self?.searchRecipeButton.isHidden = false
                self?.performSegue(withIdentifier: "RecipeList", sender: nil)
            case .failure:
                self?.activityIndicator.stopAnimating()
                self?.searchRecipeButton.isHidden = false
                self?.presentAlert(message: "Something happened wrong from the API. Please try later.")
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
}

// MARK: - Extension

extension SearchController: UITableViewDataSource, UpdateDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientCell else {
            return UITableViewCell()
        }
        let list = ingredient.ingredients[indexPath.row]
        cell.configure(title: list)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredient.ingredients.count
    }
    
    func showEmptyMessage(state: Bool) {
        noIngredientLabel.isHidden = !state
    }
    
    func throwAlert(message: String) {
        presentAlert(message: message)
    }
    
    func updateScreen(ingredientText: String) {
        searchTextField.text = ingredientText
    }
}
