import ComposableArchitecture
import LibraryFeature
import PlaylistsFeature
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
                viewController: PlaylistsViewController(
                    store: self.store.scope(
                        state: \.playlists,
                        action: AppRoot.Action.playlists
                    )
                ),
                tabBarImage: UIImage(systemName: "play.rectangle"),
                tabBarSelectedImage: UIImage(systemName: "play.rectangle.fill")
            ),
            makeTabBarViewController(
                viewController: LibraryViewController(
                    store: self.store.scope(
                        state: \.library,
                        action: AppRoot.Action.library
                    )
                ),
                tabBarImage: UIImage(systemName: "folder.badge.plus"),
                tabBarSelectedImage: UIImage(systemName: "folder.fill.badge.plus")
            ),
        ]
    }
    
    private func makeTabBarViewController(
        viewController: UIViewController,
        tabBarImage: UIImage?,
        tabBarSelectedImage: UIImage?
    ) -> UIViewController {
        let navigationController = UINavigationController(
            rootViewController: viewController
        )

        viewController.tabBarItem = UITabBarItem()
        viewController.tabBarItem.image = tabBarImage
        viewController.tabBarItem.selectedImage = tabBarSelectedImage
        
        return navigationController
    }

}
