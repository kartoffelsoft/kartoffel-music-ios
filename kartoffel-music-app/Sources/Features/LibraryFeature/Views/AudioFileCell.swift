import CommonModels
import CommonViews
import StyleGuide
import UIKit

class AudioFileCell: UICollectionViewCell {
    
    static let reuseIdentifier = "audio-file-cell"
    
    private lazy var playableImageView: PlayableImageView = {
        let view = PlayableImageView()
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 72),
            view.heightAnchor.constraint(equalToConstant: 72),
        ])
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
        backgroundColor = .theme.background400
        layer.cornerRadius = 4
        clipsToBounds = true
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(data: AudioFileCellData) {
        if let artwork = data.artwork {
            playableImageView.image = UIImage(data: artwork)
            playableImageView.layoutIfNeeded()
        }
        
        playableImageView.render(data: data.playState)
        
        switch data.playState {
        case .stop:
            titleLabel.textColor = .theme.primary

        case .playing:
            titleLabel.textColor = .theme.secondary
        }
        
        titleLabel.text = data.title ?? "Unknown title"
        subtitleLabel.text = data.artist ?? "Unknown artist"
    }
    
    private func setupConstraints() {
        playableImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(playableImageView)
        addSubview(descriptionStackView)
        addSubview(optionsButton)
        
        NSLayoutConstraint.activate([
            playableImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            playableImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            descriptionStackView.leadingAnchor.constraint(equalTo: playableImageView.trailingAnchor, constant: 16),
            descriptionStackView.trailingAnchor.constraint(equalTo: optionsButton.leadingAnchor, constant: -8),
            descriptionStackView.centerYAnchor.constraint(equalTo: playableImageView.centerYAnchor),
            
            optionsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            optionsButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            optionsButton.widthAnchor.constraint(equalToConstant: 44),
            optionsButton.heightAnchor.constraint(equalToConstant: 72),
        ])
    }

}
