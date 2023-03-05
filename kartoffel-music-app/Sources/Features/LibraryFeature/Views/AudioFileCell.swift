import StyleGuide
import UIKit

class AudioFileCell: UICollectionViewCell {
    
    static let reuseIdentifier = "audio-file-cell"
    
    var data: AudioFileCellData? {
        get { return nil }
        set {
            guard let newValue = newValue else { return }
            if let artwork = newValue.artwork {
                imageView.image = UIImage(data: artwork)
            }
            titleLabel.text = newValue.title ?? "Unknown title"
            subtitleLabel.text = newValue.artist ?? "Unknown artist"
        }
    }
    
    private let imageView = {
        let view = UIImageView()
        view.tintColor = .theme.primary
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .theme.primary
        label.font = .theme.body
        return label
    }()
    
    private let subtitleLabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .theme.primary
        label.font = .theme.footnote1
        return label
    }()
    
    private lazy var descriptionStackView = {
        let view = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        view.axis = .vertical
        view.alignment = .leading
        view.spacing = 4
        return view
    }()
    
    let optionsButton = {
        let button = UIButton()
        button.tintColor = .theme.primary
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(descriptionStackView)
        addSubview(optionsButton)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 72),
            imageView.heightAnchor.constraint(equalToConstant: 72),

            descriptionStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            descriptionStackView.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor, constant: -8),
            descriptionStackView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
            
            optionsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionsButton.widthAnchor.constraint(equalToConstant: 44),
            optionsButton.heightAnchor.constraint(equalToConstant: 72),
        ])
    }

}
