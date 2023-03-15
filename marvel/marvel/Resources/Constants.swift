import Foundation
import UIKit

// MARK: - Constants

enum Constants {
    enum Colors {
        static let white = UIColor.white
        static let black = UIColor.black
        static let main = UIColor.systemRed
        static let tint = UIColor.gray.withAlphaComponent(0.1)
        static let hardTint = UIColor.gray.withAlphaComponent(0.25)
    }
    
    enum Fonts {
        static let header = UIFont.boldSystemFont(ofSize: 24)
        static let subheader = UIFont.boldSystemFont(ofSize: 20)
        static let defaultText = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }
    
    enum Layout {
        static let borderWidth: CGFloat = 1.25
        static let cornerRadius: CGFloat = 24
        static let defaultHeight: CGFloat = 48
        static let indent: CGFloat = 16
    }
}
