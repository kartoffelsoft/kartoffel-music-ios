import CommonModels
import Foundation
import IdentifiedCollections

public class AppFileManager {
    
    public static let database = AppFileManager()

    private let url: URL
    private var audioMetaDataStorage: IdentifiedArrayOf<AudioMetaData> = []
    
    private init() {
        print("# AppFileManager init")
        
        self.url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
    }
    
    public func readAllAudioMetaData() async throws  -> [AudioMetaData] {
        return audioMetaDataStorage.elements
    }
    
    public func readAudioMetaData(id: String) async throws  -> AudioMetaData? {
        return nil
    }
    
}
