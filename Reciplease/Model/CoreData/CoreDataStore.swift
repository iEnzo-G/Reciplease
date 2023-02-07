import Foundation
import CoreData

final class CoreDataStore {
    
    let mainContext: NSManagedObjectContext
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            self.mainContext = mainContext
        }
    
    func saveRecipe(_ recipe: Recipe) {
        let newRecipeEntity = RecipeEntity(context: mainContext)
        
        newRecipeEntity.label = recipe.label
        newRecipeEntity.image = recipe.image
        newRecipeEntity.url = recipe.url
        newRecipeEntity.ingredientLines = recipe.ingredientLines
        newRecipeEntity.calories = recipe.calories
        newRecipeEntity.totalTime = Int64(recipe.totalTime)
        
        try? mainContext.save()
    }
    
    func getRecipes() -> [Recipe] {
        let fetchRequest = NSFetchRequest<RecipeEntity>(entityName: "RecipeEntity")
        guard let recipeEntities = try? mainContext.fetch(fetchRequest) else { return [] }
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
        guard let recipeEntity = try? mainContext.fetch(fetchRequest).first else { return }
        mainContext.delete(recipeEntity)
        
        try? mainContext.save()
    }
    
    // True = Exist, False = DoesntExist
    func checkRecipeExists(url: String) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeEntity")
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
        guard let count = try? mainContext.count(for: fetchRequest) else { return false }
        return count > 0
    }
}
