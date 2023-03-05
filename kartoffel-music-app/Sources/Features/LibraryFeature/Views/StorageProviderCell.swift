import UIKit
import StyleGuide

class StorageProviderCell: UICollectionViewCell {
    
    static let reuseIdentifier = "storage-provider-cell"
    
    private let image = UIImageView(
        image: .init(named: "logo-google-drive", in: Bundle.module, with: nil)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.layer.backgroundColor = UIColor.theme.foreground.cgColor
        contentView.layer.cornerRadius = 12
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        image.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 48),
            image.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

