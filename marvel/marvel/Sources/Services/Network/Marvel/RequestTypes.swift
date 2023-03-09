import Foundation

// MARK: - Request types

enum MarvelRequestType {
    case getComicsForCharacterName(String)
    case getCharactersForName(String)
    case getCharacterForID(Int)
    case getImageWith(url: String, type: MarvelImageType)
}

// MARK: - Requesting image types

enum MarvelImageType {
    case small
    case large
    case full
    
    var option: String {
        switch self {
            case .small:
                return "standard_medium"
            case .large:
                return "standard_fantastic"
            case .full:
                return ""
        }
    }
}
