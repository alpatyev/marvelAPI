import Foundation
import UIKit

// MARK: - Make label better

class GradientLabel: UILabel {
    
    private var gradientColors = [CGColor]()

    override func drawText(in rect: CGRect) {
        if let gradientColor = drawGradientColor(in: rect, colors: gradientColors) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }
    
    public func makeTextColorGradient() {
        let baseColors = [UIColor.red.cgColor,
                          UIColor.blue.cgColor,
                          UIColor.purple.cgColor]
        
        var pattern = [CGColor]()
        for _ in 0...Int.random(in: 2...5) {
            pattern.append(baseColors.randomElement() ?? UIColor.red.cgColor)
        }
        
        gradientColors = pattern
    }

    
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

extension UIImage {
    static func animatedGif(named: String, framesPerSecond: Double = 10) -> UIImage? {
        guard let asset = NSDataAsset(name: named) else { return nil }
        return animatedGif(from: asset.data, framesPerSecond: framesPerSecond)
    }

    static func animatedGif(from data: Data, framesPerSecond: Double = 10) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        let imageCount = CGImageSourceGetCount(source)
        var images: [UIImage] = []
        for i in 0 ..< imageCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                images.append(UIImage(cgImage: cgImage))
            }
        }
        return UIImage.animatedImage(with: images, duration: Double(images.count) / framesPerSecond)
    }
}
