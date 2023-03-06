import AudioFileOptionsFeature
import CommonModels
import ComposableArchitecture
import AudioFileReadAllUseCase
import AudioPlayUseCase
import GoogleDriveFeature

public struct Library: ReducerProtocol {
    
    enum PushNavigation {
        case googleDrive
    }
    
    enum ModalNavigation {
        case audioFileOptions
    }
    
    public struct State: Equatable {
        var pushNavigation: PushNavigation? = nil
        var modalNavigation: ModalNavigation? =  nil
        var googleDrive: GoogleDrive.State? = nil
        var audioFileOptions: AudioFileOptions.State? = nil
        
        var cellDataList: IdentifiedArrayOf<AudioFileCellData> = []
        var playingAudioId: String? = nil {
            willSet {
                guard let id = playingAudioId else { return }
                cellDataList[id: id] = cellDataList[id: id]?.mutatingPlayState(.stop)
            }
            
            didSet {
                guard let id = playingAudioId else { return }
                cellDataList[id: id] = cellDataList[id: id]?.mutatingPlayState(.playing)
            }
        }
        
        public init() {
        }
    }
    
    public enum Action: Equatable {
        case initialize
        case play(selection: Int)
        case playing(TaskResult<String?>)
        case receiveFileList(TaskResult<[AudioMetaData]>)
        case navigateToStorageProvider(selection: Int?)
        case navigateToAudioFileOptions(selection: Int?)
        case googleDrive(GoogleDrive.Action)
        case audioFileOptions(AudioFileOptions.Action)
    }
    
    @Dependency(\.audioFileReadAllUseCase) var audioFileReadAllUseCase
    @Dependency(\.audioPlayUseCase) var audioPlayUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialize:
                return .task {
                    await .receiveFileList(TaskResult {
                        try await audioFileReadAllUseCase.start()
                    })
                }
                
            case let .play(selection):
                let id = (state.playingAudioId != state.cellDataList[selection].id) ?
                    state.cellDataList[selection].id :
                    nil
                    
                return .task {
                    await .playing(TaskResult {
                        try await audioPlayUseCase.start(id)
                    })
                }
                
            case let .playing(.success(id)):
                state.playingAudioId = id
                return .none
                
            case .playing(.failure):
                state.playingAudioId = nil
                return .none
                
            case let .receiveFileList(.success(list)):
                state.cellDataList.removeAll()
                state.cellDataList.append(contentsOf: list.map({
                    AudioFileCellData(
                        id: $0.id,
                        title: $0.title,
                        artist: $0.artist,
                        artwork: $0.artwork,
                        playState: .stop
                    )
                }))
                return .none
                
            case .receiveFileList(.failure(_)):
                return .none
                
            case .navigateToStorageProvider(selection: .some(_)):
                state.pushNavigation = .googleDrive
                state.googleDrive = .init()
                return .none
                
            case .navigateToStorageProvider(selection: .none):
                state.pushNavigation = nil
                state.googleDrive = nil
                return .none
                
            case let .navigateToAudioFileOptions(selection: .some(index)):
                state.modalNavigation = .audioFileOptions
                state.audioFileOptions = .init(id: state.cellDataList[index].id)
                return .none
                
            case .navigateToAudioFileOptions(selection: .none):
                return .none
                
            case .googleDrive:
                return .none
                
            case .audioFileOptions(.dismiss):
                state.modalNavigation = nil
                state.audioFileOptions = nil
                return .task {
                    await .receiveFileList(TaskResult {
                        try await audioFileReadAllUseCase.start()
                    })
                }
                
            case .audioFileOptions:
                return .none
            }
        }
        .ifLet(\.googleDrive, action: /Action.googleDrive) {
            GoogleDrive()
        }
        .ifLet(\.audioFileOptions, action: /Action.audioFileOptions) {
            AudioFileOptions()
        }
        
    }
    
}
