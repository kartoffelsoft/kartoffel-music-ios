import StyleGuide
import UIKit

protocol DownloadBarViewDelegate : AnyObject {
    
    func didTapDownloadButton()
    func didTapPauseButton()
    func didTapCancelButton()
    
}

class DownloadBarView: UIView {

    weak var delegate: DownloadBarViewDelegate?
    
    private let downloadButton = {
        let button = UIButton()
        button.titleLabel?.font = .theme.caption1
        return button
    }()
    
    private let downloadingView = {
        let view = UIView()
        view.backgroundColor = .theme.background300
        return view
    }()
    
    private let downloadingIndicator = {
        let view = UIActivityIndicatorView(style: .medium)
        view.color = .theme.primary
        return view
    }()
    
    private let pauseButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "pause",
                withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)
            ),
            for: .normal
        )
        button.tintColor = .theme.primary
        return button
    }()
    
    private let cancelButton = {
        let button = UIButton()
        button.setImage(
            UIImage(
                systemName: "xmark",
                withConfiguration: UIImage.SymbolConfiguration(weight: .heavy)
            ),
            for: .normal
        )
        button.tintColor = .theme.primary
        return button
    }()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        downloadButton.addTarget(
            self,
            action: #selector(handleDownloadButtonTap),
            for: .touchUpInside
        )

        pauseButton.addTarget(
            self,
            action: #selector(handlePauseButtonTap),
            for: .touchUpInside
        )
        
        cancelButton.addTarget(
            self,
            action: #selector(handleCancelButtonTap),
            for: .touchUpInside
        )
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        downloadButton.translatesAutoresizingMaskIntoConstraints = false
        downloadingView.translatesAutoresizingMaskIntoConstraints = false
        downloadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        downloadingView.addSubview(downloadingIndicator)
        downloadingView.addSubview(pauseButton)
        downloadingView.addSubview(cancelButton)
        
        addSubview(downloadButton)
        addSubview(downloadingView)
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: topAnchor),
            downloadButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            downloadingView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            downloadingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            downloadingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            downloadingView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            downloadingIndicator.leadingAnchor.constraint(equalTo: downloadingView.leadingAnchor, constant: 20),
            downloadingIndicator.centerYAnchor.constraint(equalTo: downloadingView.centerYAnchor),
            
            cancelButton.trailingAnchor.constraint(equalTo: downloadingView.trailingAnchor, constant: -20),
            cancelButton.centerYAnchor.constraint(equalTo: downloadingView.centerYAnchor),
            
            pauseButton.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: -20),
            pauseButton.centerYAnchor.constraint(equalTo: downloadingView.centerYAnchor),
        ])
    }
    
    func render(with data: DownloadBarViewModel) {
        switch data {
        case .nothing:
            downloadButton.isHidden = false
            downloadButton.isEnabled = false
            downloadingView.isHidden = true
            downloadButton.setTitle("Download", for: .normal)
            downloadButton.setTitleColor(.theme.primary, for: .normal)
            downloadButton.backgroundColor = .theme.background300
        case let .selected(count):
            downloadButton.isHidden = false
            downloadButton.isEnabled = true
            downloadingView.isHidden = true
            downloadButton.setTitle("Download (\(count))", for: .normal)
            downloadButton.setTitleColor(.theme.background, for: .normal)
            downloadButton.backgroundColor = .theme.secondary
        case let .downloading(current, count):
            downloadButton.isHidden = true
            downloadingView.isHidden = false
            downloadingIndicator.startAnimating()
        case let .paused(current, count):
            downloadButton.isHidden = false
            downloadButton.isEnabled = true
            downloadingView.isHidden = true
            downloadButton.setTitle("Paused (\(current)/\(count))", for: .normal)
            downloadButton.setTitleColor(.theme.background, for: .normal)
            downloadButton.backgroundColor = .theme.secondary
            downloadingIndicator.stopAnimating()
        }
    }
    
    @objc private func handleDownloadButtonTap() {
        delegate?.didTapDownloadButton()
    }
    
    @objc private func handlePauseButtonTap() {
        delegate?.didTapPauseButton()
    }
    
    @objc private func handleCancelButtonTap() {
        delegate?.didTapCancelButton()
    }
}
