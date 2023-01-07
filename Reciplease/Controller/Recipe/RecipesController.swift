import UIKit

class RecipesController: UIViewController {
    
    // MARK: - Propertie
    
    var recipes: [Hit] = []
    var nextPage: Next = .init(href: "")
    private let service = RecipeService()
    
    // MARK: - Outlet
    
    @IBOutlet weak var recipesTableView: UITableView!
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipesTableView.register(UINib(nibName: "RecipeXibCell", bundle: nil), forCellReuseIdentifier: "RecipeXibCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? RecipeDetailController, let selectedCell = sender as? UITableViewCell else { return }
        guard let selectedIndexPath = recipesTableView.indexPath(for: selectedCell)?.row else { return }
        let currentRecipe = recipes[selectedIndexPath]
        destinationVC.recipes.append(currentRecipe)
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
            service.requestMore(url: nextPage.href) { [weak self] result in
                switch result {
                case let .success(item):
                    self?.nextPage = item._links.next
                    self?.recipes.append(contentsOf: item.hits)
                case .failure:
                    self?.presentAlert(message: "Something happened wrong from the API. Please try later.")
                }
            }
            recipesTableView.reloadData()
        }
    }
}
