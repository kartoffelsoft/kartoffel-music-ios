import ComposableArchitecture
import FileListReadUseCase
import GoogleDriveFeature

public struct Library: ReducerProtocol {
    
    public struct State: Equatable {
        var activeStorageProviderId: Int? = nil
        var googleDrive: GoogleDrive.State?
        
        public init() {
            googleDrive = .init()
        }
    }
    
    public enum Action: Equatable {
        case navigateToStorageProvider(selection: Int?)
        case googleDrive(GoogleDrive.Action)
    }
    
    @Dependency(\.fileListReadUseCase) var fileListReadUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
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
