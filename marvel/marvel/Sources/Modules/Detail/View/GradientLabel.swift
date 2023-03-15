import Foundation
import UIKit

// MARK: - Make label gradient when appears

final class GradientLabel: UILabel {
    
    // MARK: - Lifecycle
    
    override func drawText(in rect: CGRect) {
        if let gradientColor = drawGradientColor(in: rect,
                                                 colors: generateRandomCgColors()) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }
    
    // MARK: - Random color pattern
    
    private func generateRandomCgColors() -> [CGColor] {
        var pattern = [CGColor]()
        let baseColors = [UIColor.red.cgColor,
                          UIColor.blue.cgColor,
                          UIColor.purple.cgColor]
        
        for _ in 0...Int.random(in: 2...5) {
            pattern.append(baseColors.randomElement() ?? UIColor.red.cgColor)
        }
        return pattern
    }
    
    // MARK: - Apply gradient

    private func drawGradientColor(in rect: CGRect, colors: [CGColor]) -> UIColor? {
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.saveGState()
        defer { currentContext?.restoreGState() }

        let size = rect.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                        colors: colors as CFArray,
                                        locations: nil) else { return nil }

        let context = UIGraphicsGetCurrentContext()
        context?.drawLinearGradient(gradient,
                                    start: CGPoint.zero,
                                    end: CGPoint(x: size.width, y: 0),
                                    options: [])
        let gradientImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let image = gradientImage else { return nil }
        return UIColor(patternImage: image)
    }
}
