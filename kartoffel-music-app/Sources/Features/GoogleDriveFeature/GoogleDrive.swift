import CommonModels
import ComposableArchitecture
import GoogleSignIn
import GoogleDriveUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        var files: [FileViewModel]?
        var downloadBar: DownloadBarViewModel = .nothing
        
        var selectedFileIds: [String] {
            guard let files = files else { return [] }
            return files.compactMap { file in
                guard file.accessoryViewModel == .selected else { return nil }
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
                state.files = files.map({
                    FileViewModel(id: $0.id, name: $0.name)
                })
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
                print("# updateProgress: ", progress)
                return .none
            case let .receiveFileDownload(.success(.response(data))):
                print("# response: ")
                return .none
            case let .receiveFileDownload(.failure(error)):
                return .none
                
            case let .didSelectItemAt(index):
                if case .downloading = state.downloadBar { return .none }
                switch state.files?[index].accessoryViewModel {
                case .nothing:
                    state.files?[index].accessoryViewModel = .selected
                case .selected:
                    state.files?[index].accessoryViewModel = .nothing
                default:
                    ()
                }
                
                guard let files = state.files else { return .none }
                let count = files.filter { $0.accessoryViewModel == .selected }.count
                state.downloadBar = count == 0 ? .nothing : .selected(count)
                
                return .none
                
            case .didTapDownloadButton:
                guard !state.selectedFileIds.isEmpty else { return .none }
                state.downloadBar = .downloading(0, state.selectedFileIds.count)
                return .run { [id = state.selectedFileIds.first] send in
                    await send(.requestFileDownload(id!))
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
