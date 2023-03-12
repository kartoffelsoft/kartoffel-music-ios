import Foundation

struct PlaylistViewData: Equatable, Hashable, Identifiable {
    
    let id: UUID
    let name: String

    init(
        id: UUID,
        name: String
    ) {
        self.id = id
        self.name = name
    }
    
}
