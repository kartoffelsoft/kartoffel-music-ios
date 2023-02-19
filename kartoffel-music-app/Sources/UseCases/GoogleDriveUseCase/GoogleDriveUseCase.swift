import CommonModels
import ComposableArchitecture

public class GoogleDriveUseCase {
    
    public var setAuthorizer: () -> Void
    public var retrieveFiles: () async throws -> [FileModel]
    
    init(
        setAuthorizer: @escaping () -> Void,
        retrieveFiles: @escaping () async throws -> [FileModel]
    ) {
        self.setAuthorizer = setAuthorizer
        self.retrieveFiles = retrieveFiles
    }
    
}
