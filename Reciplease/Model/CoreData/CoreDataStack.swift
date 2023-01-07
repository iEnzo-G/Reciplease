import Foundation
import CoreData

final class CoreDataStack {
    
    // MARK: - Properties
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Reciplease")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        guard managedContext.hasChanges else { return }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - Function
    
    func saveRecipe(_ recipe: Recipe) {
        let newRecipeEntity = RecipeEntity(context: managedContext)
        
        newRecipeEntity.label = recipe.label
        newRecipeEntity.image = recipe.image
        newRecipeEntity.url = recipe.url
        newRecipeEntity.ingredientLines = recipe.ingredientLines
        newRecipeEntity.calories = recipe.calories
        newRecipeEntity.totalTime = Int64(recipe.totalTime)
        
        saveContext()
    }
    
    func getRecipes() -> [Recipe] {
        let fetchRequest = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        guard let recipeEntities = try? managedContext.fetch(fetchRequest) else { return [] }
        let recipes = recipeEntities.map { entity in
            Recipe(label: entity.label!,
                   image: entity.image!,
                   url: entity.url!,
                   ingredientLines: entity.ingredientLines!,
                   calories: entity.calories,
                   totalTime: Int(entity.totalTime))
        }
        return recipes
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        let fetchRequest = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "url == %@", recipe.url)
        guard let recipeEntity = try? managedContext.fetch(fetchRequest).first else { return }
        managedContext.delete(recipeEntity)
        saveContext()
    }
    
    // True = Exist, False = DoesntExist
    func checkRecipeExists(url: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        guard let count = try? managedContext.count(for: fetchRequest) else { return false }
        return count > 0
    }
    
}
