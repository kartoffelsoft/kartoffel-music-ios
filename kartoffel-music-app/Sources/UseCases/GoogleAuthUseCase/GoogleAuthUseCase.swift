import ComposableArchitecture
import Foundation
import GoogleSignIn
import UIKit
import XCTestDynamicOverlay

public class GoogleAuthUseCase {
    
    public var start: (UIViewController) async throws -> String
    
    init(start: @escaping (UIViewController) async throws -> String) {
        self.start = start
    }

}

extension DependencyValues {
    
    public var googleAuthUseCase: GoogleAuthUseCase {
        get { self[GoogleAuthUseCase.self] }
        set { self[GoogleAuthUseCase.self] = newValue }
    }
    
}
