import ComposableArchitecture
import Foundation

extension FileCreateUseCase: DependencyKey {
    
    static public var liveValue = FileCreateUseCase(
        start: { name, data in
            let url = FileManager.default.urls(
                for: .documentDirectory,
                in: .userDomainMask
            )[0].appendingPathComponent(name)
            
            try data.write(to: url)
        }
    )
    
}
