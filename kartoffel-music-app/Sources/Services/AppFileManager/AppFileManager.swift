import Foundation

public class AppFileManager {
    
    public static let database = AppFileManager()

    private let url: URL
    
    private init() {
        print("# AppFileManager init")
        
        self.url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
    }
    
}
