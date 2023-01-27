import ComposableArchitecture
import FilesFeature
import PlayListsFeature
import UIKit

public class AppRootViewController: UITabBarController {

    private let store: StoreOf<AppRoot>
    private let viewStore: ViewStoreOf<AppRoot>

    public init(store: StoreOf<AppRoot>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor.white
        self.tabBar.unselectedItemTintColor = UIColor.white
        
        self.viewControllers = [
            PlayListsViewController(
                store: self.store.scope(
                    state: \.playLists,
                    action: AppRoot.Action.playLists
                )
            ),
            FilesViewController(
               store: self.store.scope(
                   state: \.files,
                   action: AppRoot.Action.files
               )
           )
        ]
    }

}
