enum DownloadStateViewModel: Equatable, Hashable {
    case nothing
    case selected
    case downloading(Int)
    case completed
}
