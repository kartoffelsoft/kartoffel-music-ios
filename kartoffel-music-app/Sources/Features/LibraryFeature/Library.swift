import CommonModels
import ComposableArchitecture
import FileListReadUseCase
import GoogleDriveFeature

public struct Library: ReducerProtocol {
    
    public struct State: Equatable {
        var activeStorageProviderId: Int? = nil
        var googleDrive: GoogleDrive.State?
        
        var files: IdentifiedArrayOf<LibraryFileViewModel> = []
        
        public init() {
            googleDrive = .init()
        }
    }
    
    public enum Action: Equatable {
        case initialize
        case receiveFileList(TaskResult<[MusicMetaModel]>)
        case navigateToStorageProvider(selection: Int?)
        case googleDrive(GoogleDrive.Action)
    }
    
    @Dependency(\.fileListReadUseCase) var fileListReadUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialize:
                return .task {
                    await .receiveFileList(TaskResult {
                        try await fileListReadUseCase.start()
                    })
                }
                
            case let .receiveFileList(.success(files)):
                state.files.append(contentsOf: files.map({
                    LibraryFileViewModel(
                        id: $0.id,
                        title: $0.title,
                        artist: $0.artist,
                        artwork: $0.artwork)
                }))
                return .none
                
            case .receiveFileList(.failure(_)):
                return .none
                
            case let .navigateToStorageProvider(selection: .some(id)):
                state.activeStorageProviderId = id
                state.googleDrive = GoogleDrive.State()
                return .none
                
            case .navigateToStorageProvider(selection: .none):
                state.activeStorageProviderId = nil
                state.googleDrive = nil
                return .none
                
            case .googleDrive:
                return .none
            }
        }
        .ifLet(\.googleDrive, action: /Action.googleDrive) {
            GoogleDrive()
        }
    }
    
}
