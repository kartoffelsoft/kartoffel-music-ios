import AVFoundation
import CommonModels
import ComposableArchitecture
import Foundation

extension FileListReadUseCase: DependencyKey {
    
    static public var liveValue = FileListReadUseCase(
        start: {
            let url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0]
            
            let contents = try FileManager.default.contentsOfDirectory(
                at: url,
                includingPropertiesForKeys: nil
            )

            return try contents.compactMap {
                guard let id = try $0.resourceValues(forKeys: [.localizedNameKey]).localizedName
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
                
                return MusicMetaModel(id: id, title: title)
            }
        }
    )
    
}
