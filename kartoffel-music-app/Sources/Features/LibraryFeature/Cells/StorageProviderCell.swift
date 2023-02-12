import UIKit

class StorageProviderCell: UICollectionViewCell {
    
    static let reuseIdentifier = "storage-provider-cell"
    
    private let image = UIImageView(
        image: .init(named: "logo-google-drive", in: Bundle.module, with: nil)
    )
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    private func setupConstraints() {
        image.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(image)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: centerYAnchor),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 32),
            image.heightAnchor.constraint(equalToConstant: 32),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

