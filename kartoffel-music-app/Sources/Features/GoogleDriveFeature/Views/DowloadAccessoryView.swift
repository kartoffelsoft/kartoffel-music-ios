import UIKit
import StyleGuide

class DownloadAccessoryView: UIView {
    
    private let state: DownloadAccessoryViewData
    
    private var baseCircleLayer = CAShapeLayer()
    private var progressCircleLayer = CAShapeLayer()
    
    init(state: DownloadAccessoryViewData) {
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
            let basePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            baseCircleLayer.path = basePath.cgPath
            baseCircleLayer.fillColor = UIColor.clear.cgColor
            baseCircleLayer.lineWidth = 2.0
            baseCircleLayer.strokeColor = UIColor.theme.primary.cgColor
            layer.addSublayer(baseCircleLayer)
            
        case let .selected(selectedState):
            switch selectedState {
            case .nothing:
                let basePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                
                baseCircleLayer.path = basePath.cgPath
                baseCircleLayer.fillColor = UIColor.theme.secondary.cgColor
                baseCircleLayer.lineWidth = 2.0
                baseCircleLayer.strokeColor = UIColor.theme.secondary.cgColor
                layer.addSublayer(baseCircleLayer)
                
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
            case .waiting:
                let basePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                
                baseCircleLayer.path = basePath.cgPath
                baseCircleLayer.fillColor = UIColor.clear.cgColor
                baseCircleLayer.lineWidth = 2.0
                baseCircleLayer.strokeColor = UIColor.theme.secondary.cgColor
                baseCircleLayer.lineDashPattern = [2, 2]
                layer.addSublayer(baseCircleLayer)
                
                let imageView = UIImageView(
                    image: UIImage(
                        systemName: "arrow.down",
                        withConfiguration: UIImage.SymbolConfiguration(
                            pointSize: 12,
                            weight: .heavy
                        )
                    )
                )
                imageView.tintColor = .theme.secondary
                imageView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                ])
            case let .downloading(progress):
                let basePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
                
                baseCircleLayer.path = basePath.cgPath
                baseCircleLayer.fillColor = UIColor.clear.cgColor
                baseCircleLayer.lineWidth = 2.0
                baseCircleLayer.strokeColor = UIColor.theme.secondary.cgColor
                baseCircleLayer.lineDashPattern = [2, 2]
                layer.addSublayer(baseCircleLayer)
                
                let progressPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 10, startAngle: -.pi/2, endAngle: 2 * .pi * progress - .pi/2, clockwise: true)
                progressCircleLayer.path = progressPath.cgPath
                progressCircleLayer.fillColor = UIColor.clear.cgColor
                progressCircleLayer.lineWidth = 2.0
                progressCircleLayer.strokeColor = UIColor.theme.secondary.cgColor
                layer.addSublayer(progressCircleLayer)
                
                let imageView = UIImageView(
                    image: UIImage(
                        systemName: "arrow.down",
                        withConfiguration: UIImage.SymbolConfiguration(
                            pointSize: 12,
                            weight: .heavy
                        )
                    )
                )
                imageView.tintColor = .theme.secondary
                imageView.translatesAutoresizingMaskIntoConstraints = false
                addSubview(imageView)
                NSLayoutConstraint.activate([
                    imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                ])
            }

        case .completed:
            let basePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2, y: frame.size.height / 2), radius: 10, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            baseCircleLayer.path = basePath.cgPath
            baseCircleLayer.fillColor = UIColor.theme.background300.cgColor
            baseCircleLayer.lineWidth = 2.0
            baseCircleLayer.strokeColor = UIColor.theme.background300.cgColor
            layer.addSublayer(baseCircleLayer)
        }
    }
}
