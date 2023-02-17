import ComposableArchitecture
import GoogleSignIn

public class GoogleUserUseCase {
    
    public var start: () async throws -> GIDGoogleUser? 
    
    init(start: @escaping () async throws -> GIDGoogleUser?) {
        self.start = start
    }
    
}
