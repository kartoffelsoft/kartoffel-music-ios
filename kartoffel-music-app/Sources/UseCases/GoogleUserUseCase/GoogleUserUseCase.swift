import ComposableArchitecture
import GoogleSignIn

public class GoogleUserUseCase {
    
    public var start: () async throws -> GIDGoogleUser?
    public var store: (GIDGoogleUser) async throws -> Void
    
    init(
        start: @escaping () async throws -> GIDGoogleUser?,
        store: @escaping (GIDGoogleUser) async throws -> Void
    ) {
        self.start = start
        self.store = store
    }
    
}
