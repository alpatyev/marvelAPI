import Foundation

// MARK: - Request types

enum MarvelRequestType {
    case getCharactersForName(String)
    case getCharactersForID(Int)
    case getImageWith(url: URL?, type: MarvelImageType)
}

// MARK: - Image types

enum MarvelImageType {
    case small
    case medium
    case large
    case full
}
