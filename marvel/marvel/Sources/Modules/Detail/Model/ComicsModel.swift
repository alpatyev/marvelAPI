import Foundation

// MARK: - Specific character data

struct SpecificCharacterModel: Decodable {
    let id: Int
    let name: String
    let thumbnail: CharacterImage
    var imageData: Data?
}

// MARK: - Comics model for this character

struct MarvelComics: Decodable {
    
}
