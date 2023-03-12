import ComposableArchitecture

extension PlaylistCreateUseCase: DependencyKey {
    
    static public var liveValue = PlaylistCreateUseCase(
        start: { name in
//            try await AudioFileManager.database.createAudioFile(id: id, data: data)
        }
    )
    
}
