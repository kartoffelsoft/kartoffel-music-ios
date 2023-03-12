import CoreData
import CoreDataManager
import Foundation

public class PlaylistManager {
    
    public static let shared = PlaylistManager()
    
    private init() {}

    public func create(name: String) {
        let list = AudioPlayListEntity(context: CoreDataManager.shared.context)
        list.id = UUID()
        list.name = name
        list.files = []
        CoreDataManager.shared.save()
    }
        
    public func read() {
//        let request = NSFetchRequest<AudioPlayListEntity>(entityName: "AudioPlayListEntity")
//        let lists = try CoreDataManager.shared.context.fetch(request)
//        print("# lists: ", lists)
    }
    
}
