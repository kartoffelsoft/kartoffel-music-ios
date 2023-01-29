import Combine
import PlayListCreateFeature
import ComposableArchitecture
import StyleGuide
import UIKit
import UIKitUtils

public class PlayListsViewController: UIViewController {
    
    private let store: StoreOf<PlayLists>
    private let viewStore: ViewStoreOf<PlayLists>
    private var cancellables: [AnyCancellable] = []
    
    public init(store: StoreOf<PlayLists>) {
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
    
    public override func viewDidAppear(_ animated: Bool) {
        if !self.isMovingToParent {
            self.viewStore.send(.navigateToPlayListCreate(false))
        }
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = .theme.primary
        titleLabel.text = "Play Lists";
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(handleAddButtonTap)
        )
        addButton.tintColor = .theme.primary
        
        self.navigationItem.leftBarButtonItem = .init(customView: titleLabel)
        self.navigationItem.rightBarButtonItems = [ addButton ]
    }
    
    private func setupNavigation() {
        self.viewStore.publisher.isNavigationActive.sink { [weak self] isNavigationActive in
            guard let self = self else { return }
            if isNavigationActive {
                self.present(
                    IfLetStoreController(
                        store: self.store
                        .scope(state: \.playListCreate, action: PlayLists.Action.playListCreate)
                    ) {
                        PlayListCreateViewController(store: $0)
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
        self.viewStore.send(.navigateToPlayListCreate(true))
    }
    
}
