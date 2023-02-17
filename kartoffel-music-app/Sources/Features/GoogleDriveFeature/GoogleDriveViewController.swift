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
        
//        guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
//            return
//        }
        
        viewStore.send(.authenticate)
    }
    
    private func setupGoogleSignIn() {
        googleSignInController.delegate = self
        
        self.viewStore.publisher.needsSignIn.sink { [weak self] needsSignIn in
            guard needsSignIn else { return }
            
            guard let self = self else { return }
            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                return
            }
                    
            self.googleSignInController.signIn(withPresenting: rootViewController)
            
//            self.navigationController?.pushViewController(
//                IfLetStoreController(
//                    store: self.store
//                        .scope(state: \.googleDrive, action: Library.Action.googleDrive)
//                ) {
//                    GoogleDriveViewController(store: $0)
//                } else: {
//                    UIViewController()
//                },
//                animated: true
//            )
        }
        .store(in: &self.cancellables)
    }
    
}

extension GoogleDriveViewController: GoogleSignInControllerDelegate {
    
    func didFinishSignInProcess(result: Result<GIDGoogleUser, Error>) {
        switch(result) {
        case let .success(user):
            print("Success")
            print(user)
            break
            
        case let .failure(error):
            print("Failed: ", error.localizedDescription)
            break
        }
    }
    
}
