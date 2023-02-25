import ComposableArchitecture
import Foundation

extension FileManagerCreateUseCase: DependencyKey {
    
    static public var liveValue = FileManagerCreateUseCase(
        start: { name, data in
            let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            print("# path: ", path)
            
        }
    )
    
}
