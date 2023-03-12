import CoreData
import CoreDataManager
import Foundation

public class PlaylistManager {
    
    public static let shared = PlaylistManager()
    
    private init() {}

    public func create(name: String) {
        let list = PlaylistEntity(context: CoreDataManager.shared.context)
        list.id = UUID()
        list.name = name
        list.elements = []
        CoreDataManager.shared.save()
    }
        
    public func read() async throws {
        let request = NSFetchRequest<PlaylistEntity>(entityName: "PlaylistEntity")
        let lists = try CoreDataManager.shared.context.fetch(request)
        lists.forEach { element in
            print("# element: ", element.name)
        }
    }
    
}
