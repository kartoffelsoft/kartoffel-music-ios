import CoreData
import CoreDataManager
import Foundation

public class AudioPlayListManager {
    
    public static let shared = AudioPlayListManager()
    
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
