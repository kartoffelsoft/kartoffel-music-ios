enum DownloadAccessoryViewModel: Equatable, Hashable {
    case nothing
    case selected(SelectedState)
    case completed
    
    enum SelectedState: Equatable, Hashable {
        case nothing
        case waiting
        case downloading(Int)
    }
}
