import CommonModels
import ComposableArchitecture
import AudioFileCreateUseCase
import GoogleSignIn
import GoogleDriveUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    
    public struct State: Equatable {
        var files: IdentifiedArrayOf<FileViewData> = []
        var downloadBar: DownloadBarViewData = .nothing
        var downloadQueue: DownloadQueue = .init([])
        
        var selectedFileIds: [String] {
            return files.compactMap { file in
                guard case .selected = file.accessoryViewData else { return nil }
                return file.id
            }
        }
        
        public init() {}
    }
    
    public enum Action: Equatable {
        case initialize
        case requestFileList
        case receiveFileList(TaskResult<[FileData]>)
        case requestFileDownload
        case receiveFileDownload(TaskResult<GoogleDriveUseCase.DownloadEvent>)
        
        case didSelectItemAt(Int)
        case didTapDownloadButton
        case didTapPauseButton
        case didTapCancelButton
    }
    
    @Dependency(\.audioFileCreateUseCase) var audioFileCreateUseCase
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
                    FileViewData(id: $0.id, name: $0.name)
                }))
                return .none
                
            case let .receiveFileList(.failure(error)):
                return .none
                
            case .requestFileDownload:
                guard let id = state.downloadQueue.first else {
                    state.downloadBar = .nothing
                    return .none
                }
                return .run { send in
                    for try await event in self.googleDriveUseCase.downloadFile(id) {
                        await send(.receiveFileDownload(.success(event)), animation: .default)
                    }
                } catch: { error, send in
                    await send(.receiveFileDownload(.failure(error)), animation: .default)
                }
                .cancellable(id: id)
                
            case let .receiveFileDownload(.success(.updateProgress(progress))):
                guard let id = state.downloadQueue.first else { return .none }
                state.files[id: id]?.accessoryViewData = .selected(.downloading(progress))
                return .none
                
            case let .receiveFileDownload(.success(.response(data))):
                guard let id = state.downloadQueue.first else { return .none }
                
                state.files[id: id]?.accessoryViewData = .completed
                state.downloadQueue.removeFirst()
                state.downloadBar = .downloading(state.downloadQueue.done, state.downloadQueue.total)
                
                return .run { send in
                    try await audioFileCreateUseCase.start(id, data)
                    await send(.requestFileDownload)
                }
                
            case let .receiveFileDownload(.failure(error)):
                return .none
                
            case let .didSelectItemAt(index):
                if case .downloading = state.downloadBar { return .none }
                switch state.files[index].accessoryViewData {
                case .nothing:
                    state.files[index].accessoryViewData = .selected(.nothing)
                case .selected:
                    state.files[index].accessoryViewData = .nothing
                default:
                    ()
                }
                
                let ids = state.selectedFileIds
                state.downloadBar = ids.isEmpty ? .nothing : .selected(ids.count)
                return .none
                
            case .didTapDownloadButton:
                let ids = state.selectedFileIds
                guard !ids.isEmpty else { return .none }
                state.downloadQueue.reload(ids)
                state.downloadBar = .downloading(0, ids.count)
                ids.forEach { id in
                    state.files[id: id]?.accessoryViewData = .selected(.waiting)
                }
                return .run { send in await send(.requestFileDownload) }
                
            case .didTapPauseButton:
                guard !state.selectedFileIds.isEmpty else { return .none }
                state.downloadBar = .paused(0, state.selectedFileIds.count)
                return .none
                
            case .didTapCancelButton:
                guard !state.selectedFileIds.isEmpty else { return .none }
                guard let id = state.downloadQueue.first else { return .none }
                state.downloadQueue.reload([])
                state.downloadBar = .paused(0, state.selectedFileIds.count)
                return .cancel(id: id)
            }
        }
    }
    
}
