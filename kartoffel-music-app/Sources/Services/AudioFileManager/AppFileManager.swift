import AVFoundation
import CommonModels
import Foundation
import IdentifiedCollections

public class AudioFileManager {
    
    public static let database = AudioFileManager()

    private let url: URL
    private var audioMetaDataStorage: IdentifiedArrayOf<AudioMetaData> = []
    
    private init() {        
        self.url = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
    }
    
    public func createAudioFile(id: String, data: Data) async throws {
        try data.write(to: url.appendingPathComponent("\(id).mp3"))
    }
    
    public func readAllAudioMetaData() async throws  -> [AudioMetaData] {
        try await invalidate()
        return audioMetaDataStorage.elements
    }
    
    public func readAudioMetaData(id: String) async throws  -> AudioMetaData? {
        return audioMetaDataStorage[id: id]
    }
 
    private func invalidate() async throws {
        let contents = try FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil
        )
        
        audioMetaDataStorage.removeAll()
        audioMetaDataStorage.append(contentsOf: try contents.compactMap {
            guard let filename = try $0.resourceValues(forKeys: [.localizedNameKey]).localizedName
            else { return nil }

            let metadata = AVAsset(url: $0).commonMetadata
            
            let title = AVMetadataItem.metadataItems(
                from: metadata,
                filteredByIdentifier: .commonIdentifierTitle
            ).first?.value as? String
            
            let artist = AVMetadataItem.metadataItems(
                from: metadata,
                filteredByIdentifier: .commonIdentifierArtist
            ).first?.value as? String
            
            let albumName = AVMetadataItem.metadataItems(
                from: metadata,
                filteredByIdentifier: .commonIdentifierAlbumName
            ).first?.value as? String
            
            let artwork = AVMetadataItem.metadataItems(
                from: metadata,
                filteredByIdentifier: .commonIdentifierArtwork
            ).first?.value as? Data
            
            return AudioMetaData(
                id: (filename as NSString).deletingPathExtension,
                title: title,
                artist: artist,
                albumName: albumName,
                artwork: artwork
            )
        })
    }

}
