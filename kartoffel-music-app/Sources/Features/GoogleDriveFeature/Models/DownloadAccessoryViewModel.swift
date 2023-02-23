enum DownloadAccessoryViewModel: Equatable, Hashable {
    case nothing
    case selected
    case downloading(Int)
    case completed
}
