import UIKit
import StyleGuide

class DownloadAccessoryView: UIView {
    
    private let state: DownloadStateViewModel
    private var backgroundLayer = CAShapeLayer()
    
    init(state: DownloadStateViewModel) {
        self.state = state
        super.init(frame: .zero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        render()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func render() {
        switch state {
        case .nothing:
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            backgroundLayer.path = circularPath.cgPath
            backgroundLayer.fillColor = UIColor.clear.cgColor
            backgroundLayer.lineWidth = 2.0
            backgroundLayer.strokeColor = UIColor.theme.primary.cgColor
            layer.addSublayer(backgroundLayer)
            break
        case .selected:
            let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            backgroundLayer.path = circularPath.cgPath
            backgroundLayer.fillColor = UIColor.theme.secondary.cgColor
            backgroundLayer.lineWidth = 2.0
            backgroundLayer.strokeColor = UIColor.theme.secondary.cgColor
            layer.addSublayer(backgroundLayer)
            
            let imageView = UIImageView(
                image: UIImage(
                    systemName: "checkmark",
                    withConfiguration: UIImage.SymbolConfiguration(
                        pointSize: 12,
                        weight: .heavy
                    )
                )
            )
            imageView.tintColor = .theme.background
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
            break
        case let .downloading(progress):
            break
        case .completed:
            break
        }

    }
}
