import Combine
import PlaylistCreateFeature
import ComposableArchitecture
import StyleGuide
import UIKit
import UIKitUtils

public class PlaylistsViewController: UIViewController {
    
    private let store: StoreOf<Playlists>
    private let viewStore: ViewStoreOf<Playlists>
    private var cancellables: Set<AnyCancellable> = []
    
    private let collectionView = PlaylistsCollectionView()
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    public init(store: StoreOf<Playlists>) {
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
        
        viewStore.send(.initialize)
    }
    
    private func setupNavigation() {
        viewStore.publisher.isNavigationActive.sink { [weak self] isNavigationActive in
            guard let self = self else { return }
            if isNavigationActive {
                self.present(
                    IfLetStoreController(
                        store: self.store
                        .scope(state: \.playlistCreate, action: Playlists.Action.playlistCreate)
                    ) {
                        PlaylistCreateViewController(store: $0)
                    } else: {
                        UIViewController()
                    },
                    animated: true
                )
            } else {
                self.dismiss(animated: true)
            }
        }
        .store(in: &self.cancellables)
    }
    
    private func setupNavigationBar() {
        let label = UILabel()
        label.textColor = .theme.primary
        label.text = "Playlists";
        label.font = .systemFont(ofSize: 24, weight: .bold)
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(handleAddButtonTap)
        )
        addButton.tintColor = .theme.primary
        
        navigationItem.leftBarButtonItem = .init(customView: label)
        navigationItem.rightBarButtonItems = [ addButton ]
    }
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .theme.background
        collectionView.delegate = self
    }
    
    private func setupDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, PlaylistViewData> { [unowned self] cell, indexPath, data in
            var content = cell.defaultContentConfiguration()
            content.text = data.name ?? "Unknown"
            content.textProperties.color = .theme.primary
            content.directionalLayoutMargins = .init(top: 4, leading: 0, bottom: 4, trailing: 0)
            cell.contentConfiguration = content
            cell.backgroundConfiguration?.backgroundColor = .theme.background
        }

        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, data in
                switch(Section(rawValue: indexPath.section)) {
                case .playlists:
                    return collectionView.dequeueConfiguredReusableCell(
                        using: cellRegistration,
                        for: indexPath,
                        item: data as? PlaylistViewData
                    )
                case .none:
                    break
                }
                return nil
            }
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
    
    private func setupBindings() {
        self.viewStore.publisher.arrayOfPlaylistViewData.sink { [weak self] data in
            var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(data.elements, toSection: .playlists)
            self?.dataSource.apply(snapshot, animatingDifferences: true)
        }
        .store(in: &self.cancellables)
    }
    
    @objc private func handleAddButtonTap() {
        viewStore.send(.navigateToPlaylistCreate(true))
    }
    
}

extension PlaylistsViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch(Section(rawValue: indexPath.section)) {
        case .playlists:
            break
            
        case .none:
            break
        }
    }

}
