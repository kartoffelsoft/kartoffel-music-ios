import ComposableArchitecture
import StyleGuide
import UIKit

public class PlayListCreateViewController: UIViewController {
    
    private let store: StoreOf<PlayListCreate>
    private let viewStore: ViewStoreOf<PlayListCreate>
    
    private var scrollView: UIScrollView = .init()
    
    private let instructionLabel = {
        let label = UILabel()
        label.text = "Name your playlist"
        label.font = .theme.subhead2
        label.textColor = .theme.primary
        return label
    }()
    
    private let textField = {
        let field = UITextField()
        field.font = .theme.headline1
        field.tintColor = .theme.secondary
        field.textColor = .theme.primary
        field.textAlignment = .center
        field.text = "My playlist #1"
        
        let width = 280.0
        let height = 60.0
        
        let underline = CALayer()
        underline.frame = .init(x: 0, y: height - 8, width: width, height: 1)
        underline.backgroundColor = UIColor.theme.primary.cgColor
        
        field.borderStyle = .none
        field.layer.addSublayer(underline)
        
        NSLayoutConstraint.activate([
            field.widthAnchor.constraint(equalToConstant: width),
            field.heightAnchor.constraint(equalToConstant: height),
        ])
        return field
    }()
    
    private let createButton = {
        let button = UIButton()
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.theme.background, for: .normal)
        button.titleLabel?.font = .theme.subhead3
        button.backgroundColor = .theme.primary
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(
          top: 12, left: 24, bottom: 12, right: 24
        )
        return button
    }()
    
    private lazy var mainStackView = {
        let view = UIStackView(arrangedSubviews: [
            instructionLabel,
            textField,
            createButton
        ])
        view.axis = .vertical
        view.alignment = .center
        view.setCustomSpacing(64, after: instructionLabel)
        view.setCustomSpacing(24, after: textField)
        return view
    }()
    
    private let dismissButton = {
        let button = UIButton()
        button.tintColor = .theme.primary
        button.setImage(.init(systemName: "xmark"), for: .normal)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 44),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
        return button
    }()

    
    public init(store: StoreOf<PlayListCreate>) {
        self.store = store
        self.viewStore = ViewStore(store)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        parent?.presentationController?.delegate = self
        
        setupKeyboard()
        setupBackgroundView()
        setupConstraints()
        setupBindings()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
        textField.selectAll(nil)
    }
    
    private func setupKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(willKeyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willKeyboardMove), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupBackgroundView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [
            UIColor.theme.background200.cgColor,
            UIColor.theme.background.cgColor
        ]
        view.layer.addSublayer(gradientLayer)
    }
    
    private func setupConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(mainStackView)
        view.addSubview(scrollView)
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            mainStackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor, constant: -28),

            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    private func setupBindings() {
        createButton.addTarget(self, action: #selector(handleCreateButtonTap), for: .touchUpInside)
        dismissButton.addTarget(self, action: #selector(handleDismissButtonTap), for: .touchUpInside)
    }
    
    @objc private func willKeyboardHide() {
        scrollView.contentInset = .zero
    }

    @objc private func willKeyboardMove(notification: NSNotification) {
        guard let keyboardScreenFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        let keyboardWindowFrame = view.convert(keyboardScreenFrame, from: view.window)
        let keyboardViewFrame = view.convert(keyboardWindowFrame, from: view)
        let mainStackViewFrame = mainStackView.frame
        let offset = keyboardViewFrame.minY - mainStackViewFrame.maxY - 32
        
        guard offset.sign == .minus else { return }
        scrollView.contentInset = UIEdgeInsets(top: offset, left: 0, bottom: 0, right: 0)
    }
    
    @objc private func didTapBackground(_: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    @objc private func handleCreateButtonTap() {
        print("# handleCreateButtonTap")
    }
    
    @objc private func handleDismissButtonTap() {
        viewStore.send(.dismiss)
    }

}

extension PlayListCreateViewController: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_: UIScrollView) {
        textField.resignFirstResponder()
    }

}

extension PlayListCreateViewController: UIAdaptivePresentationControllerDelegate {
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewStore.send(.dismiss)
    }
    
}
