import ComposableArchitecture
import Foundation

extension FileManagerCreateUseCase: DependencyKey {
    
    static public var liveValue = FileManagerCreateUseCase(
        start: { name, data in
            let url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0].appendingPathComponent(name)
            
            print("# path: ", url)
            try data.write(to: url)
        }
    )
    
}
