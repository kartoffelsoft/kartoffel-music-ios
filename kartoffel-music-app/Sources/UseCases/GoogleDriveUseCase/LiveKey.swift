import ComposableArchitecture
import GoogleAPIClientForREST_Drive
import GoogleSignIn

extension GoogleDriveUseCase: DependencyKey {
    
    static public var liveValue = GoogleDriveUseCase(
        retrieveFiles: {
            let service = GTLRDriveService()
            let query = GTLRDriveQuery_FilesList.query()
            query.pageSize = 10
//            query.q = "name contains '\("e")'"
            query.q = "mimeType = 'audio/mpeg'"
            
            service.authorizer = GIDSignIn.sharedInstance.currentUser?.fetcherAuthorizer
            
            
            let result = try await withCheckedThrowingContinuation { continuation in
                service.executeQuery(query) { (ticket, results, error) in
                    continuation.resume(returning: (results as? GTLRDrive_FileList)?.files)
                }
            }
            
            print("#: ", result)

            return [String]()
        }
    )
    
}

