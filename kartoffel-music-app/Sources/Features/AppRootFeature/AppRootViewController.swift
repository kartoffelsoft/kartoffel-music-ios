import ComposableArchitecture
import FilesFeature
import PlayListsFeature
import StyleGuide
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
        
        self.tabBar.tintColor = .theme.primary
        self.tabBar.unselectedItemTintColor = .theme.primary

        self.viewControllers = [
            makeTabBarViewController(
                viewController: PlayListsViewController(
                    store: self.store.scope(
                        state: \.playLists,
                        action: AppRoot.Action.playLists
                    )
                ),
                title: "PlayLists",
                tabBarImage: UIImage(systemName: "play.rectangle"),
                tabBarSelectedImage: UIImage(systemName: "play.rectangle.fill")
            ),
            makeTabBarViewController(
                viewController: FilesViewController(
                    store: self.store.scope(
                        state: \.files,
                        action: AppRoot.Action.files
                    )
                ),
                title: "Files",
                tabBarImage: UIImage(systemName: "folder.badge.plus"),
                tabBarSelectedImage: UIImage(systemName: "folder.fill.badge.plus")
            ),
        ]
    }
    
  
    private func makeTabBarViewController(
        viewController: UIViewController,
        title: String,
        tabBarImage: UIImage?,
        tabBarSelectedImage: UIImage?
    ) -> UIViewController {
        let navigationController = UINavigationController(
            rootViewController: viewController
        )
        
        viewController.title = title
        viewController.navigationController?.navigationBar.prefersLargeTitles = true
        viewController.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.theme.primary]
        viewController.tabBarItem = UITabBarItem()
        viewController.tabBarItem.image = tabBarImage
        viewController.tabBarItem.selectedImage = tabBarSelectedImage
        
        return navigationController
    }

}
