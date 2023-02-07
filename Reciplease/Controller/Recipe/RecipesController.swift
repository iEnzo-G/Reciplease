import UIKit

class RecipesController: UIViewController {
    
    // MARK: - Properties
    
    var recipes: [Hit] = []
    var nextPage: Next = .init(href: "")
    private let service = RecipeService()
    lazy var activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.hidesWhenStopped = true
        ai.color = .white
        return ai
    }()
    
    // MARK: - Outlet
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.isAccessibilityElement = true
        recipesTableView.accessibilityValue = "Contains \(recipes.count) recipes displayed"
        recipesTableView.accessibilityHint = "List of recipes that the API found"
        recipesTableView.register(UINib(nibName: "RecipeXibCell", bundle: nil), forCellReuseIdentifier: "RecipeXibCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? RecipeDetailController, let selectedCell = sender as? UITableViewCell else { return }
        guard let selectedIndexPath = recipesTableView.indexPath(for: selectedCell)?.row else { return }
        let currentRecipe = recipes[selectedIndexPath].recipe
        destinationVC.recipe = currentRecipe
    }
}

// MARK: - Extension

extension RecipesController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeXibCell", for: indexPath) as? RecipeXibCell else { return UITableViewCell() }
        let currentRecipe = recipes[indexPath.row].recipe
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
        performSegue(withIdentifier: "RecipeDetail", sender: tableView.cellForRow(at: indexPath))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == recipesTableView.numberOfRows(inSection: indexPath.section) - 1 {
            activityIndicator.startAnimating()
            self.service.requestMore(url: self.nextPage.href) { [weak self] result in
                switch result {
                case let .success(item):
                    self?.nextPage = item._links.next
                    self?.recipes.append(contentsOf: item.hits)
                    self?.activityIndicator.stopAnimating()
                    self?.recipesTableView.reloadData()
                case .failure:
                    self?.activityIndicator.stopAnimating()
                    self?.presentAlert(message: "Something happened wrong from the API. Please try later.")
                }
                
            }
            recipesTableView.accessibilityValue = "Contains \(recipes.count) recipes displayed"
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return activityIndicator
    }
}
