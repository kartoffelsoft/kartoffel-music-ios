import UIKit

class PlaylistsCollectionView: UICollectionView {
    
    init() {
        super.init(
            frame: .zero,
            collectionViewLayout: createCollectionViewLayout()
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
    return UICollectionViewCompositionalLayout { section, _ in
        switch(Section(rawValue: section)) {
        case .playlists:
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(80)
                )
            )
            item.contentInsets = .init(top: 4, leading: 0, bottom: 4, trailing: 0)
            
//            let header = NSCollectionLayoutBoundarySupplementaryItem(
//                layoutSize: NSCollectionLayoutSize(
//                    widthDimension: .fractionalWidth(1.0),
//                    heightDimension: .absolute(64.0)
//                ),
//                elementKind: UICollectionView.elementKindSectionHeader,
//                alignment: .top
//            )
//            header.pinToVisibleBounds = true
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(500)
                ),
                subitems: [ item ]
            )

            let section = NSCollectionLayoutSection(group: group)
//            section.boundarySupplementaryItems = [ header ]
            section.contentInsets = .init(top: 0, leading: 8, bottom: 16, trailing: 8)
            return section

        default:
            return nil
        }
    }
}
