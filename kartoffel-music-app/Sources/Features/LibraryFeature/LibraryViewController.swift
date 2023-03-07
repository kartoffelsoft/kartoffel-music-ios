import AudioFileOptionsFeature
import Combine
import ComposableArchitecture
import GoogleDriveFeature
import StyleGuide
import UIKit
import UIKitUtils

public class LibraryViewController: UIViewController {
    private let store: StoreOf<Library>
    private let viewStore: ViewStoreOf<Library>
    private var cancellables: Set<AnyCancellable> = []
    
    private let collectionView = LibraryCollectionView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
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
        setupDatasource()
        setupConstraints()
        setupBindings()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
        viewStore.send(.initialize)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        if !self.isMovingToParent {
            self.viewStore.send(.navigateToStorageProvider(selection: nil))
        }
    }
    
    private func setupNavigation() {
        self.viewStore.publisher.pushNavigation.sink { [unowned self] pushNavigation in
            guard let pushNavigation = pushNavigation else {
                _ = self.navigationController?.popToViewController(self, animated: true)
                return
            }
            
            switch pushNavigation {
            case .googleDrive:
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
        }
        .store(in: &self.cancellables)
        
        self.viewStore.publisher.modalNavigation.sink { [unowned self] modalNavigation in
            guard let modalNavigation = modalNavigation else {
                self.dismiss(animated: true)
                return
            }
            
            switch modalNavigation {
            case .audioFileOptions:
                self.present(
                    IfLetStoreController(
                        store: self.store
                        .scope(state: \.audioFileOptions, action: Library.Action.audioFileOptions)
                    ) {
                        AudioFileOptionsViewController(store: $0)
                    } else: {
                        UIViewController()
                    },
                    animated: true
                )
            }
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
            AudioFileCell.self,
            forCellWithReuseIdentifier: AudioFileCell.reuseIdentifier
        )
    }
    
    private func setupDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, data in
                switch(Section(rawValue: indexPath.section)) {
                case .storageProviders:
                    return collectionView.dequeueReusableCell(
                        withReuseIdentifier: StorageProviderCell.reuseIdentifier,
                        for: indexPath
                    )
                case .localFiles:
                    let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: AudioFileCell.reuseIdentifier,
                        for: indexPath
                    ) as! AudioFileCell
                    
                    cell.optionsButton.tag = indexPath.row
                    cell.optionsButton.addTarget(
                        self,
                        action: #selector(self.handleOptionsButtonTap),
                        for: .touchUpInside
                    )
                    
                    if let data = data as? AudioFileCellData {
                        cell.render(data: data)
                    }
                    
                    return cell
                case .none:
                    break
                }
                return nil
            }
        )
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            
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
    
    private func setupBindings() {
        self.viewStore.publisher.cellDataList.sink { [weak self] cellDataList in
            var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(StorageProvider.allCases, toSection: .storageProviders)
            snapshot.appendItems((cellDataList.elements), toSection: .localFiles)
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
        .store(in: &self.cancellables)
    }
    
    @objc private func handleOptionsButtonTap(_ sender: UIButton) {
        viewStore.send(.navigateToAudioFileOptions(selection: sender.tag))
    }
    
}

extension LibraryViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(Section(rawValue: indexPath.section)) {
        case .storageProviders:
            self.viewStore.send(.navigateToStorageProvider(selection: indexPath.row))
            break

        case .localFiles:
            self.viewStore.send(.play(selection: indexPath.row))
            break
            
        case .none:
            break
        }
    }

}
