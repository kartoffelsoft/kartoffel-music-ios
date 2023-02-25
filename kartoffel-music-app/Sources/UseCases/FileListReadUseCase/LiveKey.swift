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
            
            return contents.compactMap {
                try? $0.resourceValues(forKeys: [.localizedNameKey]).localizedName
            }
        }
    )
    
}
