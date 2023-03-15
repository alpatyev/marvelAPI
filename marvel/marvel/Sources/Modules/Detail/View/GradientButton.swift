import Foundation
import UIKit

// MARK: - Just regular UIButton with gradient appearance and animation when selected

final class GradientButton: UIButton {
    
    // MARK: - Private properties
    
    private var gradientColors: [UIColor]
    private let startPoint: CGPoint
    private let endPoint: CGPoint
    
    // MARK: - Tap animation
    
    override var isHighlighted: Bool {
        didSet {
            let newOpacity: Float = isHighlighted ? 0.6 : 0.85
            let newRadius: CGFloat = isHighlighted ? 6.0 : 4.0
            
            let shadowOpacityAnimation = CABasicAnimation()
            shadowOpacityAnimation.keyPath = "shadowOpacity"
            shadowOpacityAnimation.fromValue = layer.shadowOpacity
            shadowOpacityAnimation.toValue = newOpacity
            shadowOpacityAnimation.duration = 0.1
            
            let shadowRadiusAnimation = CABasicAnimation()
            shadowRadiusAnimation.keyPath = "shadowRadius"
            shadowRadiusAnimation.fromValue = layer.shadowRadius
            shadowRadiusAnimation.toValue = newRadius
            shadowRadiusAnimation.duration = 0.1
            
            layer.add(shadowOpacityAnimation, forKey: "shadowOpacity")
            layer.add(shadowRadiusAnimation, forKey: "shadowRadius")
            
            layer.shadowOpacity = newOpacity
            layer.shadowRadius = newRadius
            
            let xScale: CGFloat = isHighlighted ? 1.10 : 1.0
            let yScale: CGFloat = isHighlighted ? 1.05 : 1.0
            UIView.animate(withDuration: 0.1) {
                let transformation = CGAffineTransform(scaleX: xScale, y: yScale)
                self.transform = transformation
            }
        }
    }
    
    // MARK: - Lifecycle
    
    required init(startPoint: CGPoint = CGPoint(x: 0, y: 0.5),
                  endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) {
        self.gradientColors = [UIColor]()
        self.startPoint = startPoint
        self.endPoint = endPoint
        super.init(frame: .zero)
        randomizeColors()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError(String(#line))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let halfOfButtonHeight = layer.frame.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 10,
                                         left: halfOfButtonHeight,
                                         bottom: 10, right: halfOfButtonHeight)
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.clear
        
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = gradientColors.map { $0.cgColor }
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        gradient.cornerRadius = halfOfButtonHeight
        
        if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
            layer.replaceSublayer(oldGradient, with: gradient)
        } else {
            layer.insertSublayer(gradient, below: nil)
        }
                
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds,
                                        cornerRadius: halfOfButtonHeight).cgPath
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.85
        layer.shadowRadius = 4.0
    }
    
    // MARK: - Randomize gradient
    
    private func randomizeColors() {
        var pattern = [UIColor]()
        let baseColors = [UIColor.red,
                          UIColor.blue,
                          UIColor.purple]
        
        for _ in 0...Int.random(in: 2...5) {
            pattern.append(baseColors.randomElement() ?? UIColor.red)
        }
        gradientColors = pattern
    }
}
