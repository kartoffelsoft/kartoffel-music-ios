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
        
    public func read() async throws -> [PlaylistEntity] {
        return try CoreDataManager.shared.context.fetch(
            NSFetchRequest<PlaylistEntity>(
                entityName: "PlaylistEntity"
            )
        )
    }
    
}
