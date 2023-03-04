import Combine
import CommonModels
import ComposableArchitecture
import GoogleSignIn
import StyleGuide
import UIKit

public class GoogleDriveViewController: UIViewController {
    
    private enum Section: CaseIterable {
        case main
    }
    
    private let store: StoreOf<GoogleDrive>
    private let viewStore: ViewStoreOf<GoogleDrive>
    
    private let googleSignInController = GoogleSignInController()
    private let downloadBarView = DownloadBarView()

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, FileViewData>!

    private var cancellables: Set<AnyCancellable> = []

    public init(store: StoreOf<GoogleDrive>) {
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
        setupDatasource()
        setupConstraints()
        setupBindings()
        
        collectionView.delegate = self
        googleSignInController.delegate = self
        downloadBarView.delegate = self
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        googleSignInController.authenticate()
    }
    
    private func setupBindings() {
        self.viewStore.publisher.files.sink { [weak self] files in
            var snapshot = NSDiffableDataSourceSnapshot<Section, FileViewData>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(files.elements)
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
        .store(in: &self.cancellables)
        
        self.viewStore.publisher.downloadBar.sink { [weak self] downloadBar in
            self?.downloadBarView.render(with: downloadBar)
        }
        .store(in: &self.cancellables)
    }
    
    private func setupNavigationBar() {
        let signOutButton = UIBarButtonItem(
            image: .init(systemName: "rectangle.portrait.and.arrow.forward"),
            style: .plain,
            target: self,
            action: #selector(handleSignOutButtonTap)
        )
        signOutButton.tintColor = .theme.primary
        parent?.navigationItem.rightBarButtonItems = [ signOutButton ]
        
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .clear
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.list(using: configuration)
        )
        collectionView.backgroundColor = .theme.background
    }
    
    private func setupDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, FileViewData> { cell, _, file in
            var content = cell.defaultContentConfiguration()
            content.text = file.name
            content.textProperties.color = .theme.primary
            cell.contentConfiguration = content
            cell.backgroundConfiguration?.backgroundColor = .theme.background
            cell.accessories = [
                .customView(
                    configuration: UICellAccessory.CustomViewConfiguration(
                        customView: DownloadAccessoryView(state: file.accessoryViewData),
                        placement: .trailing(displayed: .always),
                        tintColor: .theme.primary
                    )
                )
            ]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, FileViewData>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, file in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: file
                )
            }
        )
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        downloadBarView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(downloadBarView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            downloadBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            downloadBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            downloadBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            downloadBarView.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    @objc private func handleSignOutButtonTap() {
        googleSignInController.signOut()
        navigationController?.popViewController(animated: true)
    }
    
}

extension GoogleDriveViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewStore.send(.didSelectItemAt(indexPath.row))
    }
    
}

extension GoogleDriveViewController: GoogleSignInControllerDelegate {
    
    func didCompleteSignIn(user: GIDGoogleUser?) {
        guard let _ = user else { return }
        viewStore.send(.initialize)
        viewStore.send(.requestFileList)
    }
    
}

extension GoogleDriveViewController: DownloadBarViewDelegate {
    
    func didTapDownloadButton() {
        viewStore.send(.didTapDownloadButton)
    }
    
    func didTapPauseButton() {
        viewStore.send(.didTapPauseButton)
    }
    
    func didTapCancelButton() {
        viewStore.send(.didTapCancelButton)
    }
    
}
