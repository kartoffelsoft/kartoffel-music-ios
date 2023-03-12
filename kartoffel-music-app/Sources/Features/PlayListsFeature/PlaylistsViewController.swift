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
    
    private func setupNavigation() {
        viewStore.publisher.isNavigationActive.sink { [weak self] isNavigationActive in
            guard let self = self else { return }
            if isNavigationActive {
                self.present(
                    IfLetStoreController(
                        store: self.store
                        .scope(state: \.playListCreate, action: Playlists.Action.playListCreate)
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
    
    @objc private func handleAddButtonTap() {
        viewStore.send(.navigateToPlayListCreate(true))
    }
    
}
