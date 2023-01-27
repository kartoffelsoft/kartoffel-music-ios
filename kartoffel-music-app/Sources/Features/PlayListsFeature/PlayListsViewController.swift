import ComposableArchitecture
import UIKit

public class PlayListsViewController: UIViewController {
    
    private let store: StoreOf<PlayLists>
    private let viewStore: ViewStoreOf<PlayLists>
    
    public init(store: StoreOf<PlayLists>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
        
        self.tabBarItem = UITabBarItem()
        self.tabBarItem.image = UIImage(systemName: "play.rectangle")
        self.tabBarItem.selectedImage = UIImage(systemName: "play.rectangle.fill")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "PlayLists"
        tabBarItem.title = ""
        navigationController?.navigationBar.prefersLargeTitles = true
    }

}
