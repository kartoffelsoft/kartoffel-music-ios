import CommonModels
import ComposableArchitecture
import Foundation

public class GoogleDriveUseCase {
    
    public var setAuthorizer: () -> Void
    public var retrieveFileList: () async throws -> [FileData]
    public var downloadFile: @Sendable (_ id: String) -> AsyncThrowingStream<DownloadEvent, Error>

    public enum DownloadEvent: Equatable {
        case response(Data)
        case updateProgress(Double)
    }
    
    init(
        setAuthorizer: @escaping () -> Void,
        retrieveFileList: @escaping () async throws -> [FileData],
        downloadFile: @escaping @Sendable (_ id: String) -> AsyncThrowingStream<DownloadEvent, Error>
    ) {
        self.setAuthorizer = setAuthorizer
        self.retrieveFileList = retrieveFileList
        self.downloadFile = downloadFile
    }
    
}
