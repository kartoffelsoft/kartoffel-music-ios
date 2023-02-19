import CommonModels
import ComposableArchitecture
import GoogleAPIClientForREST_Drive
import GoogleSignIn

extension GoogleDriveUseCase: DependencyKey {
    
    static public var liveValue = GoogleDriveUseCase(
        setAuthorizer: {
            service.authorizer = GIDSignIn.sharedInstance.currentUser?.fetcherAuthorizer
        },
        retrieveFiles: {
            let query = GTLRDriveQuery_FilesList.query()
            query.pageSize = 10
            query.q = "mimeType = 'audio/mpeg'"
            
            let result: [GTLRDrive_File]? = try await withCheckedThrowingContinuation { continuation in
                service.executeQuery(query) { (ticket, results, error) in
                    continuation.resume(returning: (results as? GTLRDrive_FileList)?.files)
                }
            }
            
            guard let result = result else { return [] }
            
            return result.compactMap { file in
                return FileModel(from: file)
            }
        }
    )
    
}

private let service = GTLRDriveService()

private extension FileModel {
    
    init?(from: GTLRDrive_File) {
        guard let id = from.identifier, let name = from.name else { return nil }
        self.init(id: id, name: name)
    }
    
}
