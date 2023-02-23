import UIKit

class LibraryCollectionView: UICollectionView {
    
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
        case .storageProviders:
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(0.33),
                    heightDimension: .fractionalHeight(1)
                )
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(120)
                ),
                subitems: [ item ]
            )
            group.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(52.0)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [ header ]
            section.orthogonalScrollingBehavior = .continuous
            return section

        case .localFiles:
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(48)
                )
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(500)
                ),
                subitems: [ item ]
            )
            group.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)

            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(50.0)
                ),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            header.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
            header.pinToVisibleBounds = true
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [ header ]
            return section

        default:
            return nil
        }
    }
}
