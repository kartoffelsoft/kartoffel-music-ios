import StyleGuide
import UIKit

class DownloadBarView: UIView {

    private let downloadButton = {
        let button = UIButton()
        button.titleLabel?.font = .theme.caption1
        return button
    }()
    
    private let downloadingView = {
        let view = UIView()
        return view
    }()
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        
        addSubview(downloadButton)
        addSubview(downloadingView)
        
        NSLayoutConstraint.activate([
            downloadButton.topAnchor.constraint(equalTo: topAnchor),
            downloadButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            downloadingView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            downloadingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            downloadingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            downloadingView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }
    
    func render(with data: DownloadBarViewModel) {
        switch data {
        case .nothing:
            downloadButton.isHidden = false
            downloadingView.isHidden = true
            downloadButton.setTitle("Download", for: .normal)
            downloadButton.setTitleColor(.theme.primary, for: .normal)
            downloadButton.backgroundColor = .theme.background300
        case let .selected(count):
            downloadButton.isHidden = false
            downloadingView.isHidden = true
            downloadButton.setTitle("Download (\(count))", for: .normal)
            downloadButton.setTitleColor(.theme.primary, for: .normal)
            downloadButton.backgroundColor = .theme.secondary
        case let .downloading(current, count):
            downloadButton.isHidden = true
            downloadingView.isHidden = false
        case .completed:
            downloadButton.isHidden = false
            downloadingView.isHidden = true
        }
    }
    
}
