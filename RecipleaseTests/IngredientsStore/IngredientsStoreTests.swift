import XCTest
@testable import Reciplease

final class IngredientsStoreTests: XCTestCase {
    
    
    func test_GivenIngredient_ThenNoMoreEmptyMessage() {
        let (sut, controller) = makeSUT()
        sut.addIngredient("Tomato")
        XCTAssertFalse(controller.expectedIsEmpty)
    }
    
    func test_GivenIngredients_WhenClear_ThenShowEmptyMessage() {
        let (sut, controller) = makeSUT()
        sut.addIngredient("Tomato")
        sut.addIngredient("Butter")
        XCTAssertEqual(controller.expectedIsEmpty, false)
        sut.clearList()
        XCTAssertEqual(controller.expectedIsEmpty, true)
    }
    
    func test_GivenIngredient_WhenTrySearchRecipe_ThenShowAlertIfIsEmpty() {
        let (sut, controller) = makeSUT()
        sut.searchRecipe()
        XCTAssertEqual(controller.expectedMessage, "You must add at least one ingredient first.")
        sut.addIngredient("Tomato")
        sut.searchRecipe()
        XCTAssertEqual(controller.expectedMessage, "You must add at least one ingredient first.")
    }
    
    func test_GivenIngredient_WhenClearList_ThenListIsEmpty() {
        let (sut, _) = makeSUT()
        sut.ingredientText = "Tomato"
        sut.addIngredient(sut.ingredientText)
        XCTAssertEqual(sut.ingredients[0], "Tomato")
        sut.clearList()
        XCTAssertEqual(sut.ingredients.isEmpty, true)
    }
    
    func test_GivenAddEmptyOrSameIngredient_ThenShowErrorMessage() {
        let (sut, controller) = makeSUT()
        sut.ingredientText = ""
        sut.addIngredient(sut.ingredientText)
        XCTAssertEqual(controller.expectedMessage, "You must first specify a new ingredient.")
        sut.ingredientText = "Tomato"
        sut.addIngredient(sut.ingredientText)
        sut.ingredientText = "Tomato"
        sut.addIngredient(sut.ingredientText)
        XCTAssertEqual(controller.expectedMessage, "You have already add this ingredient.")
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> (model: IngredientsStore, controller: ControllerSpy) {
        let model = IngredientsStore()
        let controller = ControllerSpy()
        model.delegate = controller
        return (model, controller)
    }
    
    ///  A spy used to obtain information that the model returns to the controller.
    private class ControllerSpy: NSObject, UpdateDelegate {
        var expectedMessage: String = ""
        var expectedIngredient: String = ""
        var expectedIsEmpty: Bool = true
        
        func throwAlert(message: String) {
            expectedMessage = message
        }
        func updateScreen(ingredientText: String) {
            expectedIngredient = ingredientText
        }
        func showEmptyMessage(state: Bool) {
            expectedIsEmpty = state
        }
    }
}
