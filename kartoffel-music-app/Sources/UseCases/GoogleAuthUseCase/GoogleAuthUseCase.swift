import ComposableArchitecture
import Foundation
import GoogleSignIn
import XCTestDynamicOverlay

public class GoogleAuthUseCase {
    
    public var start: () -> Bool
    
    init(
        start: @escaping () -> Bool
    ) {
        self.start = start
    }
    
}

extension GoogleAuthUseCase: DependencyKey {
    
    static public var liveValue = GoogleAuthUseCase(
        start: {
            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
              print("There is no root view controller!")
              return false
            }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
                guard let signInResult = signInResult else {
                    print("Error! \(String(describing: error))")
                    return
                }
                print("Logged In")
                
                let driveScope = "https://www.googleapis.com/auth/drive.readonly"
                let grantedScopes = signInResult.user.grantedScopes
                if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
                    let additionalScopes = ["https://www.googleapis.com/auth/drive.readonly"]
                    guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
                        return
                    }

                    currentUser.addScopes(additionalScopes, presenting: rootViewController) { signInResult, error in
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
            return true
        }
    )
    
}

extension GoogleAuthUseCase: TestDependencyKey {
    
    static public var testValue = GoogleAuthUseCase(
        start: XCTUnimplemented("\(GoogleAuthUseCase.self).start")
    )
    
}

extension DependencyValues {
    
    public var googleAuthUseCase: GoogleAuthUseCase {
        get { self[GoogleAuthUseCase.self] }
        set { self[GoogleAuthUseCase.self] = newValue }
    }
    
}
