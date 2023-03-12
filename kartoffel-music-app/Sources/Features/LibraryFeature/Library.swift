import AudioFileOptionsFeature
import CommonModels
import ComposableArchitecture
import AudioFileReadAllUseCase
import AudioPlayUseCase
import AudioStopUseCase
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
        var arrayOfFileViewData: IdentifiedArrayOf<AudioFileViewData> = []
        
        var playingAudioId: String? = nil {
            willSet {
                guard let id = playingAudioId else { return }
                arrayOfFileViewData[id: id] = arrayOfFileViewData[id: id]?.mutatingPlayState(.stop)
            }
            
            didSet {
                guard let id = playingAudioId else { return }
                arrayOfFileViewData[id: id] = arrayOfFileViewData[id: id]?.mutatingPlayState(.playing(progress: 0))
            }
        }
        
        var playingAudioProgress: Double = 0 {
            didSet {
                guard let id = playingAudioId else { return }
                arrayOfFileViewData[id: id] = arrayOfFileViewData[id: id]?.mutatingPlayState(.playing(progress: playingAudioProgress))
            }
        }
        
        public init() {
        }
    }
    
    public enum Action: Equatable {
        case initialize
        case play(selection: Int)
        case playing(TaskResult<AudioPlayUseCase.Event>)
        case receiveFileList(TaskResult<[AudioMetaData]>)
        case navigateToStorageProvider(selection: Int?)
        case navigateToAudioFileOptions(selection: Int?)
        case googleDrive(GoogleDrive.Action)
        case audioFileOptions(AudioFileOptions.Action)
    }
    
    @Dependency(\.audioFileReadAllUseCase) var audioFileReadAllUseCase
    @Dependency(\.audioPlayUseCase) var audioPlayUseCase
    @Dependency(\.audioStopUseCase) var audioStopUseCase
    
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
                let id = state.arrayOfFileViewData[selection].id
                guard id != state.playingAudioId else {
                    state.playingAudioId = nil
                    return .run { send in
                        Task.cancel(id: id)
                        try await audioStopUseCase.start()
                    }
                }

                return .run { send in
                    for try await event in self.audioPlayUseCase.start(id) {
                        await send(.playing(.success(event)), animation: .default)
                    }
                } catch: { error, send in
                    await send(.playing(.failure(error)), animation: .default)
                }
                .cancellable(id: id)
                
            case let .playing(.success(.start(id, _))):
                state.playingAudioId = id
                return .none
                
            case let .playing(.success(.playing(_, duration, elapsed))):
                state.playingAudioProgress = elapsed / duration
                return .none
                
            case let .playing(.success(.finish(id))):
                state.playingAudioId = nil
                return .cancel(id: id)
                
            case .playing(.failure):
                guard let id = state.playingAudioId else { return .none }
                state.playingAudioId = nil
                return .cancel(id: id)
                
            case let .receiveFileList(.success(list)):
                state.arrayOfFileViewData.removeAll()
                state.arrayOfFileViewData.append(contentsOf: list.map({
                    AudioFileViewData(
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
                state.audioFileOptions = .init(id: state.arrayOfFileViewData[index].id)
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
