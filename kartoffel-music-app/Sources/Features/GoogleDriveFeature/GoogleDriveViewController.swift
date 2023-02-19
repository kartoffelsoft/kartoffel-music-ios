import Combine
import ComposableArchitecture
import GoogleSignIn
import UIKit

public class GoogleDriveViewController: UIViewController {
    
    private let store: StoreOf<GoogleDrive>
    private let viewStore: ViewStoreOf<GoogleDrive>
    
    private let googleSignInController = GoogleSignInController()
    
    private var cancellables: [AnyCancellable] = []
    
    public init(store: StoreOf<GoogleDrive>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupGoogleSignIn()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        googleSignInController.authenticate()
    }
    
    private func setupGoogleSignIn() {
        googleSignInController.delegate = self
    }
    
}

extension GoogleDriveViewController: GoogleSignInControllerDelegate {
    
    func didCompleteSignIn(user: GIDGoogleUser?) {
        guard let _ = user else { return }
        viewStore.send(.initialize)
        viewStore.send(.requestFiles)
    }
    
}
