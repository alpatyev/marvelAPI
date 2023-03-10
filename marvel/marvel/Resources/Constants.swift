import Foundation
import UIKit

// MARK: - Constants

enum Constants {
    enum Colors {
        static let white = UIColor.white
        static let black = UIColor.black
        static let main = UIColor.systemRed
        static let tint = UIColor.gray.withAlphaComponent(0.1)
    }
    
    enum Fonts {
        static let header = UIFont.boldSystemFont(ofSize: 24)
        static let monospaced = UIFont.monospacedSystemFont(ofSize: 20, weight: .regular)
        static let monospacedDescriptopn = UIFont.systemFont(ofSize: 16, weight: .thin)
        static let subheader = UIFont.boldSystemFont(ofSize: 20)
    }
    
    enum Layout {
        static let borderWidth: CGFloat = 1.25
        static let cornerRadius: CGFloat = 24
        static let defaultHeight: CGFloat = 48
        static let indent: CGFloat = 16
    }
    
    enum Mock {
        static let emptyItem: CharacterItem = CharacterItem(id: 0,
                                                            name: "",
                                                            thumbnail: CharacterImage(path: ""))
    }
}
