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
    
    private let collectionView = LibraryCollectionView()
    
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
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
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
        let label = UILabel()
        label.textColor = .theme.primary
        label.text = "Library";
        label.font = .systemFont(ofSize: 24, weight: .bold)

        navigationItem.leftBarButtonItem = .init(customView: label)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupCollectionView() {
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

extension LibraryViewController: UICollectionViewDelegate {
    
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
            header.title.text = "Download"
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

