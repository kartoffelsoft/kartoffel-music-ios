import CommonModels
import ComposableArchitecture
import GoogleSignIn
import GoogleDriveUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    
    public struct State: Equatable {
        var files: IdentifiedArrayOf<FileViewModel> = []
        var downloadBar: DownloadBarViewModel = .nothing
        
        var downloadQueue: DownloadQueue?
        
        var selectedFileIds: [String] {
            return files.compactMap { file in
                guard case .selected = file.accessoryViewModel else { return nil }
                return file.id
            }
        }
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case initialize
        case requestFileList
        case receiveFileList(TaskResult<[FileModel]>)
        case requestFileDownload(String)
        case receiveFileDownload(TaskResult<GoogleDriveUseCase.DownloadEvent>)
        
        case didSelectItemAt(Int)
        case didTapDownloadButton
        case didTapPauseButton
        case didTapCancelButton
    }
    
    @Dependency(\.googleDriveUseCase) var googleDriveUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialize:
                googleDriveUseCase.setAuthorizer()
                return .none

            case .requestFileList:
                return .task {
                    await .receiveFileList(TaskResult {
                        try await googleDriveUseCase.retrieveFileList()
                    })
                }
            case let .receiveFileList(.success(files)):
                state.files.append(contentsOf: files.map({
                    FileViewModel(id: $0.id, name: $0.name)
                }))
                return .none
            case let .receiveFileList(.failure(error)):
                return .none
                
            case let .requestFileDownload(id):
                return .run { send in
                    for try await event in self.googleDriveUseCase.downloadFile(id) {
                        await send(.receiveFileDownload(.success(event)), animation: .default)
                    }
                } catch: { error, send in
                    await send(.receiveFileDownload(.failure(error)), animation: .default)
                }
                .cancellable(id: id)
                
            case let .receiveFileDownload(.success(.updateProgress(progress))):
                guard let id = state.downloadQueue?.first else { return .none }
                state.files[id: id]?.accessoryViewModel = .selected(.downloading(progress))
                return .none
            case let .receiveFileDownload(.success(.response(data))):
                guard let id = state.downloadQueue?.first else { return .none }
                state.files[id: id]?.accessoryViewModel = .completed
                state.downloadQueue?.removeFirst()
                guard let queue = state.downloadQueue,
                      let id = queue.first else {
                    state.downloadBar = .nothing
                    state.downloadQueue = nil
                    return .none
                }
                state.downloadBar = .downloading(queue.done, queue.total)
                return .run { send in
                    await send(.requestFileDownload(id))
                }
            case let .receiveFileDownload(.failure(error)):
                return .none
                
            case let .didSelectItemAt(index):
                if case .downloading = state.downloadBar { return .none }
                switch state.files[index].accessoryViewModel {
                case .nothing:
                    state.files[index].accessoryViewModel = .selected(.nothing)
                case .selected:
                    state.files[index].accessoryViewModel = .nothing
                default:
                    ()
                }
                
                let ids = state.selectedFileIds
                state.downloadBar = ids.isEmpty ? .nothing : .selected(ids.count)
                return .none
                
            case .didTapDownloadButton:
                let ids = state.selectedFileIds
                guard !ids.isEmpty else { return .none }
                state.downloadQueue = DownloadQueue(ids)
                state.downloadBar = .downloading(0, ids.count)
                ids.forEach { id in
                    state.files[id: id]?.accessoryViewModel = .selected(.waiting)
                }
                guard let id = state.downloadQueue?.first else { return .none }
                return .run { send in
                    await send(.requestFileDownload(id))
                }
                
            case .didTapPauseButton:
                guard !state.selectedFileIds.isEmpty else { return .none }
                state.downloadBar = .paused(0, state.selectedFileIds.count)
                return .none
                
            case .didTapCancelButton:
                guard !state.selectedFileIds.isEmpty else { return .none }
                state.downloadBar = .paused(0, state.selectedFileIds.count)
                return .none
            }
        }
    }
    
}
