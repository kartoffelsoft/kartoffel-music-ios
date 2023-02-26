import Foundation

struct LibraryFileViewModel: Equatable, Hashable, Identifiable {
    
    let id: String
    let title: String?
    let artwork: Data?

    init(
        id: String,
        title: String?,
        artwork: Data?
    ) {
        self.id = id
        self.title = title
        self.artwork = artwork
    }
    
}
