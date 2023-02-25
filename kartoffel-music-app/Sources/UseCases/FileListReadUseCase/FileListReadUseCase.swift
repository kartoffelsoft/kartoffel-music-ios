import ComposableArchitecture
import Foundation

public class FileListReadUseCase {
    
    public var start: () async throws -> [String]
    
    init(start: @escaping () async throws -> [String]) {
        self.start = start
    }
    
}
