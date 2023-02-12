import StyleGuide
import UIKit

class FileCell: UICollectionViewCell {
    
    static let reuseIdentifier = "file-cell"
    
    private let name = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    private func setupConstraints() {
        name.translatesAutoresizingMaskIntoConstraints = false
        name.text = "file1.mp3"
        name.textColor = .theme.primary
        
        addSubview(name)
        
        NSLayoutConstraint.activate([
            name.leadingAnchor.constraint(equalTo: leadingAnchor),
            name.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
