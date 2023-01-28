import ComposableArchitecture
import StyleGuide
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
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.textColor = .theme.primary
        titleLabel.text = "Files";
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

    @objc private func handleAddButtonTap() {
        print("# handleAddButtonTap")
    }
    
}
