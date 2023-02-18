import ComposableArchitecture

extension GoogleDriveUseCase: DependencyKey {
    
    static public var liveValue = GoogleDriveUseCase(
        retrieveFiles: {
            return [String]()
        }
    )
    
}
