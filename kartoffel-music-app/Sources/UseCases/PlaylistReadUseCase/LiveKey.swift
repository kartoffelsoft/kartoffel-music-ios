
import CommonModels
import ComposableArchitecture
import PlaylistManager

extension PlaylistReadUseCase: DependencyKey {
    
    static public var liveValue = PlaylistReadUseCase(
        start: { id in
            let lists = try await PlaylistManager.shared.read()
            return lists.compactMap { list in
                guard let id = list.id,
                      let name = list.name,
                      let elements = list.elements else {
                    return nil
                }
                return PlaylistData(id: id, name: name, elements: elements)
            }
        }
    )
    
}
