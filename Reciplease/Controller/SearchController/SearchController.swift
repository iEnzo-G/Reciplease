import UIKit

class SearchController: UIViewController {
    
    // MARK: - Properties
    
    private let ingredient = Ingredient()
    private let service = RecipeService()
    
    // MARK: - Outlets
    
    @IBOutlet weak var noIngredientLabel: UILabel!
    @IBOutlet weak var searchRecipeButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var ingredientTableView: UITableView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        recipeRequest()
    }
    
    private func recipeRequest() {
        service.request(ingredientList: ingredient.list) { [weak self] result in
            switch result {
            case let .success(item):
                print(item)
            case .failure:
                self?.presentAlert(message: "Something happened wrong from the API. Please try later.")
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        searchTextField.resignFirstResponder()
    }
}

// MARK: - Extension

extension SearchController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientTableViewCell else {
            return UITableViewCell()
        }
        let list = ingredient.list[indexPath.row]
        cell.configure(title: list)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredient.list.count
    }
}

extension SearchController: UpdateDelegate {
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
