import Foundation
import UIKit

// MARK: - Simply adding a shadow

extension UIView {
    func addShadow(with color: UIColor = .purple, opacity: CGFloat = 0.25) {
        self.layer.shadowColor = color.withAlphaComponent(opacity).cgColor
        self.layer.shadowOffset = CGSize(width: 10, height: 10)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0
        self.layer.masksToBounds = false
    }
}
