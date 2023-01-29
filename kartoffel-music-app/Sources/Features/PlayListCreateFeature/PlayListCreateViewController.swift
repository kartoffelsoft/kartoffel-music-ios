import ComposableArchitecture
import StyleGuide
import UIKit

public class PlayListCreateViewController: UIViewController {
    
    private let store: StoreOf<PlayListCreate>
    private let viewStore: ViewStoreOf<PlayListCreate>
    
    public init(store: StoreOf<PlayListCreate>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .cyan
        self.parent?.presentationController?.delegate = self
    }

}

extension PlayListCreateViewController: UIAdaptivePresentationControllerDelegate {
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.viewStore.send(.dismiss)
    }
    
}
