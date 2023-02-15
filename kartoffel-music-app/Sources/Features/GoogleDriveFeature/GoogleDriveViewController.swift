import ComposableArchitecture
import GoogleSignIn
import UIKit

public class GoogleDriveViewController: UIViewController {
    
    private let store: StoreOf<GoogleDrive>
    private let viewStore: ViewStoreOf<GoogleDrive>
    
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
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
            guard let signInResult = signInResult else {
                print("Error! \(String(describing: error))")
                return
            }

            let driveScope = "https://www.googleapis.com/auth/drive.readonly"
            let grantedScopes = signInResult.user.grantedScopes
            if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
                let additionalScopes = ["https://www.googleapis.com/auth/drive.readonly"]
                guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
                    return
                }

                currentUser.addScopes(additionalScopes, presenting: self) { signInResult, error in
                    guard error == nil else { return }
                    guard let signInResult = signInResult else { return }

                    let grantedScopes = signInResult.user.grantedScopes
                    if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
                        print("#: Still not granted")
                    } else {
                        print("#: Granted")
                    }
                }
            }
        }
    }
    
}
