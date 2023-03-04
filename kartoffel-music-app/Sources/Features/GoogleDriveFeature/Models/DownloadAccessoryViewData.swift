enum DownloadAccessoryViewData: Equatable, Hashable {
    case nothing
    case selected(SelectedState)
    case completed
    
    enum SelectedState: Equatable, Hashable {
        case nothing
        case waiting
        case downloading(Double)
    }
}
