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
    private let downloadButton = {
        let button = UIButton()
        button.setTitle("DOWNLOAD", for: .normal)
        button.setTitleColor(.theme.background, for: .normal)
        button.setTitleColor(.theme.primary, for: .disabled)
        button.backgroundColor = .theme.background300
        button.isEnabled = false
        return button
    }()
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, FileViewModel>!

    private var cancellables: [AnyCancellable] = []

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
        
        setupBindings()
        setupNavigationBar()
        setupGoogleSignIn()
        setupCollectionView()
        setupDatasource()
        setupConstraints()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        googleSignInController.authenticate()
    }
    
    private func setupBindings() {
        self.viewStore.publisher.files.sink { [weak self] files in
            guard let files = files else { return }
            var snapshot = NSDiffableDataSourceSnapshot<Section, FileViewModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(files)
            self?.dataSource.apply(snapshot, animatingDifferences: false)
        }
        .store(in: &self.cancellables)
        
        downloadButton.addTarget(
            self,
            action: #selector(handleDownloadButtonTap),
            for: .touchUpInside
        )
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
    }
    
    private func setupGoogleSignIn() {
        googleSignInController.delegate = self
    }
    
    private func setupCollectionView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .clear
        
        collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout.list(using: configuration)
        )
        collectionView.delegate = self
        collectionView.backgroundColor = .theme.background
    }
    
    private func setupDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, FileViewModel> { cell, _, file in
            var content = cell.defaultContentConfiguration()
            content.text = file.name
            content.textProperties.color = .theme.primary
            cell.contentConfiguration = content
            cell.backgroundConfiguration?.backgroundColor = .theme.background
            cell.accessories = [
                .customView(
                    configuration: UICellAccessory.CustomViewConfiguration(
                        customView: DownloadAccessoryView(state: file.downloadState),
                        placement: .trailing(displayed: .always),
                        tintColor: .theme.primary
                    )
                )
            ]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, FileViewModel>(
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
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        view.addSubview(downloadButton)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: downloadButton.topAnchor),
            
            downloadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            downloadButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            downloadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            downloadButton.heightAnchor.constraint(equalToConstant: 44),
        ])
    }
    
    @objc private func handleSignOutButtonTap() {
        googleSignInController.signOut()
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleDownloadButtonTap() {
        
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
        viewStore.send(.requestFiles)
    }
    
}
