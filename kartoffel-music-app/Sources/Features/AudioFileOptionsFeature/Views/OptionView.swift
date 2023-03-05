import StyleGuide
import UIKit

class OptionView: UIView {

    private let imageView = {
        let view = UIImageView()
        view.tintColor = .theme.primary
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let optionLabel = {
        let label = UILabel()
        label.textColor = .theme.primary
        label.textAlignment = .left
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()
    
    convenience init(text: String? = nil, image: UIImage? = nil) {
        self.init(frame: .zero)
        optionLabel.text = text
        optionLabel.font = .theme.subhead2
        imageView.image = image
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        optionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(optionLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 28),
            imageView.heightAnchor.constraint(equalToConstant: 28),

            optionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            optionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            optionLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),
        ])
    }

}
