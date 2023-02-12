import ComposableArchitecture
import StyleGuide
import UIKit

public class LibraryViewController: UIViewController {
    private let store: StoreOf<Library>
    private let viewStore: ViewStoreOf<Library>
    
    private let collectionView: UICollectionView = {
        return UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout { section, _ in
                let padding: CGFloat = 8
                
                switch(Section(rawValue: section)) {
                case .storageProviders:
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(0.33),
                            heightDimension: .fractionalHeight(1)
                        )
                    )
                    
                    item.contentInsets = .init(
                        top: padding,
                        leading: padding,
                        bottom: padding,
                        trailing: padding
                    )
                    
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(120)
                        ),
                        subitems: [ item ]
                    )

                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    return section

                case .localFiles:
                    let item = NSCollectionLayoutItem(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .absolute(40)
                        )
                    )

                    item.contentInsets = .init(
                        top: padding,
                        leading: padding,
                        bottom: padding,
                        trailing: padding
                    )

                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: .init(
                            widthDimension: .fractionalWidth(1),
                            heightDimension: .estimated(500)
                        ),
                        subitems: [ item ]
                    )

                    return NSCollectionLayoutSection(group: group)

                default:
                    return nil
                }
            }
        )
    }()
    
    public init(store: StoreOf<Library>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupCollectionView()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = .theme.primary
        titleLabel.text = "Library";
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        
        self.navigationItem.leftBarButtonItem = .init(customView: titleLabel)
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            StorageProviderCell.self,
            forCellWithReuseIdentifier: StorageProviderCell.reuseIdentifier
        )
        collectionView.register(
            FileCell.self,
            forCellWithReuseIdentifier: FileCell.reuseIdentifier
        )
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
}

extension LibraryViewController: UICollectionViewDelegate {
    
    private enum Section: Int, CaseIterable {
        case storageProviders
        case localFiles
    }
    
    public func numberOfSections(
        in collectionView: UICollectionView
    ) -> Int {
        return Section.allCases.count
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch(Section(rawValue: section)) {
        case .storageProviders:
            return 1
        case .localFiles:
            return 8
        case .none:
            return 0
        }
    }

}

extension LibraryViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch(Section(rawValue: indexPath.section)) {
        case .storageProviders:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StorageProviderCell.reuseIdentifier,
                for: indexPath
            ) as! StorageProviderCell
            return cell

        case .localFiles:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FileCell.reuseIdentifier,
                for: indexPath
            ) as! FileCell
            return cell
            
        case .none:
            return UICollectionViewCell()
        }
    }

}

