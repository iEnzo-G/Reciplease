import Foundation
import CoreData

final class CoreDataStack {
    
    // MARK: - Properties
    
    static let shared = CoreDataStack()
    
    let storeContainer: NSPersistentContainer
    let mainContext: NSManagedObjectContext
    
    init() {
        storeContainer = {
            let container = NSPersistentContainer(name: "Reciplease")
            container.loadPersistentStores { (storeDescription, error) in
                if let error = error as NSError? {
                    print("Unresolved error \(error), \(error.userInfo)")
                }
            }
            return container
        }()
        
        mainContext =  storeContainer.newBackgroundContext()
    }
}
