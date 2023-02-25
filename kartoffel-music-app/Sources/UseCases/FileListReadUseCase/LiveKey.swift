import ComposableArchitecture
import Foundation

extension FileListReadUseCase: DependencyKey {
    
    static public var liveValue = FileListReadUseCase(
        start: {
            let url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0]
            
            return []
        }
    )
    
}
