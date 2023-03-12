import Foundation

public struct PlaylistData: Equatable, Hashable {
    
    public let id: UUID
    public let name: String
    public let elements: [String]
    
    public init(
        id: UUID,
        name: String,
        elements: [String]
    ) {
        self.id = id
        self.name = name
        self.elements = elements
    }
    
}
