import XCTest
@testable import Reciplease

final class CoreDataStoreTests: XCTestCase {
    
    func test_GivenRecipe_ThenSaveRecipeToCoreData() {
        let coreDataStack = FakeCoreDataStack()
        let sut = CoreDataStore(mainContext: coreDataStack.mainContext)
        let recipe = Recipe(label: "newLabel",
                            image: "https://www.image.com",
                            url: "https://www.recipe.com",
                            ingredientLines: ["ingredients"],
                            calories: 0,
                            totalTime: 0)
        sut.saveRecipe(recipe)
        XCTAssertTrue(sut.checkRecipeExists(url: "https://www.recipe.com"))
    }
    
    func test_GivenRecipe_ThenDeleteRecipeToCoreData() {
        let coreDataStack = FakeCoreDataStack()
        let sut = CoreDataStore(mainContext: coreDataStack.mainContext)
        let recipe = Recipe(label: "newLabel",
                            image: "https://www.image.com",
                            url: "https://www.recipe.com",
                            ingredientLines: ["ingredients"],
                            calories: 0,
                            totalTime: 0)
        sut.saveRecipe(recipe)
        XCTAssertTrue(sut.checkRecipeExists(url: "https://www.recipe.com"))
        
        sut.deleteRecipe(recipe)
        XCTAssertFalse(sut.checkRecipeExists(url: "https://www.recipe.com"))
    }
    
    func test_GivenAskCoreDataForRecipe_ThenGetRecipe() {
        let coreDataStack = FakeCoreDataStack()
        let sut = CoreDataStore(mainContext: coreDataStack.mainContext)
        let recipe = Recipe(label: "newLabel",
                            image: "https://www.image.com",
                            url: "https://www.recipe.com",
                            ingredientLines: ["ingredients"],
                            calories: 0,
                            totalTime: 0)
        sut.saveRecipe(recipe)
        
        var recipesStore: [Recipe] = []
        recipesStore = sut.getRecipes()
        
        XCTAssertEqual(recipesStore[0].url, "https://www.recipe.com")
    }
}

