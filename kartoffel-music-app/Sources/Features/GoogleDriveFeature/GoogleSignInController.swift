import GoogleSignIn

protocol GoogleSignInControllerDelegate: AnyObject {
    
    func didFinishSignInProcess(result: Result<GIDGoogleUser, Error>)
    
}

class GoogleSignInController {
    
    weak var delegate: GoogleSignInControllerDelegate?
    
    init() {}
    
    public func signIn(withPresenting: UIViewController) {
        GIDSignIn.sharedInstance.signIn(withPresenting: withPresenting) { [weak self] signInResult, error in
            guard let self = self else { return }
            guard let signInResult = signInResult else {
                self.delegate?.didFinishSignInProcess(result: .failure(error ?? NSError()))
                return
            }
            
            let driveScope = "https://www.googleapis.com/auth/drive.readonly"
            let grantedScopes = signInResult.user.grantedScopes
            
            if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
                let additionalScopes = ["https://www.googleapis.com/auth/drive.readonly"]
                guard let currentUser = GIDSignIn.sharedInstance.currentUser else { return }
            
                currentUser.addScopes(additionalScopes, presenting: withPresenting) { [weak self] signInResult, error in
                    guard let self = self else { return }
                    guard let signInResult = signInResult else {
                        self.delegate?.didFinishSignInProcess(result: .failure(error ?? NSError()))
                        return
                    }
                    
                    let grantedScopes = signInResult.user.grantedScopes
                    if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
                        self.delegate?.didFinishSignInProcess(result: .failure(error ?? NSError()))
                    } else {
                        self.delegate?.didFinishSignInProcess(result: .success(signInResult.user))
                    }
                }
            } else {
                self.delegate?.didFinishSignInProcess(result: .success(signInResult.user))
            }
        }
    }
}
