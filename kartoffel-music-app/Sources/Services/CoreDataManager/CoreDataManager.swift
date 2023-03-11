import CoreData
import Foundation

public class CoreDataManager {
    
    public static let shared = CoreDataManager()
    
    public let container: NSPersistentContainer
    public var context: NSManagedObjectContext
    
    private init() {
        let url = Bundle.module.url(forResource: "CoreDataContainer", withExtension: ".momd")!
        let model = NSManagedObjectModel(contentsOf: url)!
        container = NSPersistentCloudKitContainer(name: "CoreDataContainer", managedObjectModel: model)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        context = container.viewContext
    }

    public func save () {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error {
                print("Error saving CoreData \(error.localizedDescription)")
            }
        }
    }
}
