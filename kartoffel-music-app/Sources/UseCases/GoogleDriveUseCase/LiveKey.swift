import CommonModels
import ComposableArchitecture
import GoogleAPIClientForREST_Drive
import GoogleSignIn

extension GoogleDriveUseCase: DependencyKey {
    
    static public var liveValue = GoogleDriveUseCase(
        setAuthorizer: {
            service.authorizer = GIDSignIn.sharedInstance.currentUser?.fetcherAuthorizer
        },
        retrieveFileList: {
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
        },
        downloadFile: { id in
            .init { continuation in
                Task {
                    do {
                        let url = "https://www.googleapis.com/drive/v3/files/\(id)?alt=media"
                        let fetcher = service.fetcherService.fetcher(withURLString: url)
                        
                        fetcher.receivedProgressBlock = { _, totalBytesReceived in
                            if let fileSize = fetcher.response?.expectedContentLength {
                                let progress: Double = Double(totalBytesReceived) / Double(fileSize)
                                print(progress)
                                continuation.yield(.updateProgress(progress))
                            }
                        }
                        
                        let result: Data? = try await withCheckedThrowingContinuation { continuation in
                            fetcher.beginFetch(completionHandler: { data, error in
                                if error == nil {
                                    continuation.resume(returning: data)
                                } else {
                                    print("Error: \(String(describing: error?.localizedDescription))")
                                }
                            })
                        }

                        guard let result = result else { return continuation.finish() }
                        continuation.yield(.response(result))
                        continuation.finish()
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
            }
//            let url = "https://www.googleapis.com/drive/v3/files/\(id)?alt=media"
//            let fetcher = service.fetcherService.fetcher(withURLString: url)
//
//
//            fetcher.beginFetch(completionHandler: { fileData, error in
//
//                if error == nil {
//
//                    print("finished downloading Data...")
//                    print(fileData as Any)
//
//
//                } else {
//
//                    print("Error: \(String(describing: error?.localizedDescription))")
//                }
//            })
//
//            fetcher.receivedProgressBlock = { _, totalBytesReceived in
//
//                if let fileSize = fetcher.response?.expectedContentLength {
//
//                    let progress: Double = Double(totalBytesReceived) / Double(fileSize)
//                    print(progress)
//                }
//            }
//            print("Downloading: ", id)
//            return true
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
