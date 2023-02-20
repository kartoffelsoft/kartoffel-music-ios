import GoogleSignIn

protocol GoogleSignInControllerDelegate: AnyObject {
    
    func didCompleteSignIn(user: GIDGoogleUser?)
    
}

class GoogleSignInController {
    
    weak var delegate: GoogleSignInControllerDelegate?
    
    init() {}
    
    public func authenticate() {
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn() { [weak self] user, _ in
                guard let _ = user else {
                    self?.delegate?.didCompleteSignIn(user: nil)
                    return
                }
                
                GIDSignIn.sharedInstance.currentUser?.refreshTokensIfNeeded() { [weak self] user, _ in
                    self?.delegate?.didCompleteSignIn(user: user)
                }
            }
        } else {
            signIn()
        }
    }
    
    public func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    private func signIn() {
        guard let root = UIApplication.shared.windows.first?.rootViewController else {
            self.delegate?.didCompleteSignIn(user: nil)
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: root) { [weak self] result, error in
            guard let result = result else {
                self?.delegate?.didCompleteSignIn(user: nil)
                return
            }
            
            let driveScope = "https://www.googleapis.com/auth/drive.readonly"

            guard let grantedScopes = result.user.grantedScopes,
                  grantedScopes.contains(driveScope) else {
                guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
                    self?.delegate?.didCompleteSignIn(user: nil)
                    return
                }
                
                currentUser.addScopes([driveScope], presenting: root) { [weak self] result, error in
                    guard let result = result else {
                        self?.delegate?.didCompleteSignIn(user: nil)
                        return
                    }
                    
                    guard let grantedScopes = result.user.grantedScopes,
                          grantedScopes.contains(driveScope) else {
                        self?.delegate?.didCompleteSignIn(user: nil)
                        return
                    }
     
                    self?.delegate?.didCompleteSignIn(user: result.user)
                }
                return
            }

            self?.delegate?.didCompleteSignIn(user: result.user)
        }
    }
    
}
