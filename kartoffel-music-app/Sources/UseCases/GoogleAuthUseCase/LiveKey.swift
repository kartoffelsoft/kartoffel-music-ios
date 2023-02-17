import ComposableArchitecture
import Foundation
import GoogleSignIn
import XCTestDynamicOverlay

extension GoogleAuthUseCase: DependencyKey {
    
    enum Failure: Error {
        case system
        case signIn
    }
    
    static public var liveValue = GoogleAuthUseCase(
        start: { rootViewController in
            let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, hint: nil)

            print("Logged In")
            print(result.user)
            return result.user.accessToken.tokenString

//            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
//                guard let signInResult = signInResult else {
//                    print("Error! \(String(describing: error))")
//                    return
//                }
//                print("Logged In")

//                let driveScope = "https://www.googleapis.com/auth/drive.readonly"
//                let grantedScopes = signInResult.user.grantedScopes
//                if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
//                    let additionalScopes = ["https://www.googleapis.com/auth/drive.readonly"]
//                    guard let currentUser = GIDSignIn.sharedInstance.currentUser else {
//                        return
//                    }
//
//                    currentUser.addScopes(additionalScopes, presenting: rootViewController) { signInResult, error in
//                        guard error == nil else { return }
//                        guard let signInResult = signInResult else { return }
//
//                        let grantedScopes = signInResult.user.grantedScopes
//                        if grantedScopes == nil || !grantedScopes!.contains(driveScope) {
//                            print("#: Still not granted")
//                        } else {
//                            print("#: Granted")
//                        }
//                    }
//                }
//
//            }
        }
    )
    
}
