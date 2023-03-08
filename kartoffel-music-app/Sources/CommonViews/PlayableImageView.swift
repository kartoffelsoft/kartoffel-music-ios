import CommonModels
import StyleGuide
import UIKit

public class PlayableImageView: UIImageView {
    
    private let backgroundView: UIView = .init()
    
    private let foregroundView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .theme.primary
        return view
    }()
    
    private let progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.clear.cgColor
        layer.lineWidth = 2.0
        layer.strokeColor = UIColor.theme.primary.cgColor
        return layer
    }()
    
    public convenience init() {
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    public override var image: UIImage? {
        didSet {
            layoutIfNeeded()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func render(data: PlayState) {
        switch data {
        case .stop:
            backgroundView.backgroundColor = .theme.background
            backgroundView.layer.opacity = 0.5
            
            foregroundView.image = UIImage(
                systemName: "play.fill",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 20,
                    weight: .heavy
                )
            )
            
            progressLayer.path = nil
            
        case let .playing(progress):
            backgroundView.backgroundColor = .theme.background400
            backgroundView.layer.opacity = 1
            
            foregroundView.image = UIImage(
                systemName: "pause",
                withConfiguration: UIImage.SymbolConfiguration(
                    pointSize: 20,
                    weight: .heavy
                )
            )

            progressLayer.path = UIBezierPath(arcCenter: CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2), radius: 16, startAngle: -.pi/2, endAngle: 2 * .pi * progress - .pi/2, clockwise: true).cgPath
        }
    }
    
    private func setupConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        foregroundView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(backgroundView)
        addSubview(foregroundView)
        layer.addSublayer(progressLayer)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            foregroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            foregroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
}
