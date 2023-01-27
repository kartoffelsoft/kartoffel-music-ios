import ComposableArchitecture
import UIKit

public class FilesViewController: UIViewController {
    
    private let store: StoreOf<Files>
    private let viewStore: ViewStoreOf<Files>
    
    public init(store: StoreOf<Files>) {
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
