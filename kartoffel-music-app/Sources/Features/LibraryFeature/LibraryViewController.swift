import ComposableArchitecture
import StyleGuide
import UIKit

public class LibraryViewController: UIViewController {
    
    private let store: StoreOf<Library>
    private let viewStore: ViewStoreOf<Library>
    
    public init(store: StoreOf<Library>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupConstraints()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = .theme.primary
        titleLabel.text = "Library";
        titleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        
        self.navigationItem.leftBarButtonItem = .init(customView: titleLabel)
    }
    
    private func setupConstraints() {

    }
    
}
