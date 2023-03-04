enum DownloadBarViewData: Equatable, Hashable {
    
    case nothing
    case selected(Int)
    case downloading(Int, Int)
    case paused(Int, Int)
    
}
