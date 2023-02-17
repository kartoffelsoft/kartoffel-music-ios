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
            self.delegate?.didFinishSignInProcess(result: .success(signInResult.user))
        }
    }
}
