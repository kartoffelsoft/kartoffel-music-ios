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
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, FileModel>!
    
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
            var snapshot = NSDiffableDataSourceSnapshot<Section, FileModel>()
            snapshot.appendSections(Section.allCases)
            snapshot.appendItems(files)
            self?.dataSource.apply(snapshot, animatingDifferences: true)
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
        collectionView.allowsSelection = false
        collectionView.backgroundColor = .clear
        collectionView.backgroundView?.backgroundColor = .red
        collectionView.keyboardDismissMode = .interactive
    }
    
    private func setupDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, FileModel> { cell, _, file in
            var content = cell.defaultContentConfiguration()
            content.text = file.name
            content.textProperties.color = .theme.primary
            cell.contentConfiguration = content
            cell.backgroundConfiguration?.backgroundColor = .theme.background
            cell.accessories = [
                .multiselect(
                    displayed: .always,
                    options: UICellAccessory.MultiselectOptions(tintColor: .theme.primary)
                )
            ]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, FileModel>(
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
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc private func handleSignOutButtonTap() {
        googleSignInController.signOut()
        navigationController?.popViewController(animated: true)
    }
}

extension GoogleDriveViewController: GoogleSignInControllerDelegate {
    
    func didCompleteSignIn(user: GIDGoogleUser?) {
        guard let _ = user else { return }
        viewStore.send(.initialize)
        viewStore.send(.requestFiles)
    }
    
}
