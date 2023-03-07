import CommonModels
import StyleGuide
import UIKit

public class PlayableImageView: UIImageView {
    
    private let backgroundView: UIView = .init()
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func render(data: PlayState) {
        switch data {
        case .stop:
            backgroundView.backgroundColor = .theme.background
            backgroundView.layer.opacity = 0.5
        case .playing:
            backgroundView.backgroundColor = .theme.background400
            backgroundView.layer.opacity = 1
        }
    }
    
    private func setupConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundView)

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}
