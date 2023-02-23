enum DownloadBarViewModel: Equatable, Hashable {
    case nothing
    case selected(Int)
    case downloading(Int, Int)
    case completed
}
