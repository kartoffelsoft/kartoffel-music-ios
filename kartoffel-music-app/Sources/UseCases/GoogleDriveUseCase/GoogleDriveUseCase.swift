import ComposableArchitecture

public class GoogleDriveUseCase {
    
    public var retrieveFiles: () async throws -> [String]
    
    init(
        retrieveFiles: @escaping () async throws -> [String]
    ) {
        self.retrieveFiles = retrieveFiles
    }
    
}
