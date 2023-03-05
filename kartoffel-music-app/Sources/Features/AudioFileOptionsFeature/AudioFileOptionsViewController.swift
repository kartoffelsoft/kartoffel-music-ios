import Combine
import ComposableArchitecture
import StyleGuide
import UIKit

public class AudioFileOptionsViewController: UIViewController {
    
    private let store: StoreOf<AudioFileOptions>
    private let viewStore: ViewStoreOf<AudioFileOptions>
    private var cancellables: Set<AnyCancellable> = []
    
    private let artworkImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.textColor = .theme.primary
        label.font = .theme.subhead1
        return label
    }()
    
    private let subtitleLabel = {
        let label = UILabel()
        label.textColor = .theme.primary
        label.font = .theme.footnote1
        return label
    }()
    
    private lazy var descriptionStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 8
        return view
    }()
    
    private let deleteOptionView = OptionView(text: "Delete", image: .init(systemName: "minus.circle"))
    
    private let closeButton = {
        let button = UIButton()
        button.titleLabel?.font = .theme.subhead2
        button.tintColor = .theme.primary
        button.setTitle("Close", for: .normal)
        return button
    }()
    
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
        parent?.presentationController?.delegate = self
        
        setupBackgroundView()
        setupConstraints()
        setupBindings()
        
        viewStore.send(.initialize)
    }
    
    private func setupBackgroundView() {
        let blurEffectView = UIVisualEffectView(
            effect: UIBlurEffect(style: UIBlurEffect.Style.dark)
        )
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    private func setupConstraints() {
        artworkImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        deleteOptionView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(artworkImageView)
        view.addSubview(descriptionStackView)
        view.addSubview(deleteOptionView)
        view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            artworkImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            artworkImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            artworkImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            artworkImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionStackView.topAnchor.constraint(equalTo: artworkImageView.bottomAnchor, constant: 12),
            descriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            deleteOptionView.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: 24),
            deleteOptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,  constant: 16),
            deleteOptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            deleteOptionView.heightAnchor.constraint(equalToConstant: 56),

            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            closeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            closeButton.heightAnchor.constraint(equalToConstant: 56),
        ])
    }
    
    private func setupBindings() {
        self.viewStore.publisher.viewData.sink { [weak self] data in
            guard let data = data else { return }
            
            if let artwork = data.artwork {
                self?.artworkImageView.image = UIImage(data: artwork)
            } else {
                self?.artworkImageView.image = UIImage(systemName: "music.note")
            }
            
            self?.titleLabel.text = data.title
            self?.subtitleLabel.text = data.artist
            
            
        }
        .store(in: &self.cancellables)
        
        closeButton.addTarget(
            self,
            action: #selector(handleCloseButtonTap),
            for: .touchUpInside
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDeleteOptionTap))
        deleteOptionView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleCloseButtonTap() {
        viewStore.send(.dismiss)
    }
    
    @objc private func handleDeleteOptionTap() {
        viewStore.send(.delete)
    }
    
}

extension AudioFileOptionsViewController: UIAdaptivePresentationControllerDelegate {
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewStore.send(.dismiss)
    }
    
}
