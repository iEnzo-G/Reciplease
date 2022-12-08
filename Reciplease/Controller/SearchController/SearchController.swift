import UIKit

class SearchController: UIViewController {
    
    // MARK: - Properties
    
    var ingredient = Ingredient()
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    // MARK: - Actions
    
    @IBAction func tappedClearButton(_ sender: UIButton) {
        searchTextField.text = ""
        ingredient.list.removeAll()
        ingredientTableView.reloadData()
        noIngredientLabel.isHidden = false
    }
    
    @IBAction func typedInSearchTextField(_ sender: UITextField) {
        searchTextField.text = ""
    }
    
    @IBAction func tappedAddButton(_ sender: UIButton) {
        guard let ingredientText = searchTextField.text, ingredientText != "" else {
            self.presentAlert(message: "You must first specify a new ingredient.")
            return
        }
        ingredient.list.append(ingredientText)
        searchTextField.text = ""
        noIngredientLabel.isHidden = true
        ingredientTableView.reloadData()
    }
    
    @IBAction func tappedSearchRecipeButton(_ sender: UIButton) {
        guard !ingredient.list.isEmpty else {
            self.presentAlert(message: "You must add at least one ingredient first.")
            return
        }
       searchRecipe()
    }
    
    private func searchRecipe() {
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
