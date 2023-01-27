import ComposableArchitecture
import UIKit

public class PlayListsViewController: UIViewController {
    
    private let store: StoreOf<PlayLists>
    private let viewStore: ViewStoreOf<PlayLists>
    
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
    }

}
