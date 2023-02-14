import UIKit

class HeaderReusableView: UICollectionReusableView {
    
    static let reuseIdentifier = "header-view"
    
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        title.textColor = .theme.primary
        title.font = .systemFont(ofSize: 20, weight: .semibold)
        backgroundColor = .theme.background
        setupConstraints()
    }
    
    private func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false

        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: leadingAnchor),
            title.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
