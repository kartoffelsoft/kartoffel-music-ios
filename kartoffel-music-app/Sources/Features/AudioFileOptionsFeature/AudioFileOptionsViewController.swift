import Combine
import ComposableArchitecture
import StyleGuide
import UIKit

public class AudioFileOptionsViewController: UIViewController {
    
    private let store: StoreOf<AudioFileOptions>
    private let viewStore: ViewStoreOf<AudioFileOptions>
    private var cancellables: Set<AnyCancellable> = []
    
    public init(store: StoreOf<AudioFileOptions>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffectView = UIVisualEffectView(
            effect: UIBlurEffect(style: UIBlurEffect.Style.dark)
        )
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        parent?.presentationController?.delegate = self
        
        viewStore.send(.initialize)
    }
    
}

extension AudioFileOptionsViewController: UIAdaptivePresentationControllerDelegate {
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewStore.send(.dismiss)
    }
    
}
