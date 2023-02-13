import Combine
import ComposableArchitecture
import GoogleDriveFeature
import StyleGuide
import UIKit
import UIKitUtils

public class LibraryViewController: UIViewController {
    private let store: StoreOf<Library>
    private let viewStore: ViewStoreOf<Library>
    private var cancellables: [AnyCancellable] = []
    
    private var collectionView: UICollectionView!
    
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
        
        setupNavigation()
        setupNavigationBar()
        setupCollectionView()
        setupConstraints()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        if !self.isMovingToParent {
            self.viewStore.send(.navigateToStorageProvider(selection: nil))
        }
    }
    
    private func setupNavigation() {
        self.viewStore.publisher.activeStorageProviderId.sink { [weak self] activeStorageProviderId in
            guard let self = self else { return }
            guard let activeStorageProviderId = activeStorageProviderId else {
                _ = self.navigationController?.popToViewController(self, animated: true)
                return
            }
            
            self.navigationController?.pushViewController(
                IfLetStoreController(
                    store: self.store
                        .scope(state: \.googleDrive, action: Library.Action.googleDrive)
                ) {
                    GoogleDriveViewController(store: $0)
                } else: {
                    UIViewController()
                },
                animated: true
            )
        }
        .store(in: &self.cancellables)
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = .theme.primary
        titleLabel.text = "Library";
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        
        self.navigationItem.leftBarButtonItem = .init(customView: titleLabel)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: createCollectionViewLayout()
        )
        collectionView.backgroundColor = .theme.background
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            HeaderReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderReusableView.reuseIdentifier
        )
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

extension LibraryViewController {
    private func createCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { section, _ in
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
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(50.0)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [ header ]
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

                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(50.0)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                header.pinToVisibleBounds = true
                
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [ header ]
                return section

            default:
                return nil
            }
        }
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
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderReusableView.reuseIdentifier,
            for: indexPath
        ) as! HeaderReusableView
        
        switch(Section(rawValue: indexPath.section)) {
        case .storageProviders:
            header.title.text = "Storage Providers"
        case .localFiles:
            header.title.text = "Local Storage"
        case .none:
            break
        }
        
        return header
    }
    
    public func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        switch(Section(rawValue: section)) {
        case .storageProviders:
            return 1
        case .localFiles:
            return 20
        case .none:
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(Section(rawValue: indexPath.section)) {
        case .storageProviders:
            self.viewStore.send(.navigateToStorageProvider(selection: indexPath.row))
            break

        case .localFiles:
            break
            
        case .none:
            break
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

