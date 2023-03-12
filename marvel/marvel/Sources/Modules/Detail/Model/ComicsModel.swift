import Foundation

// MARK: - Specific character data

struct SpecificCharacterModel: Decodable {
    let id: Int?
    let name: String?
    let description: String?
    let modified: String?
    let thumbnail: CharacterImage?
    let resourceURI: String?
    let comics: Container?
    let series: Container?
    let stories: Container?
    let events: Container?
    var imageData: Data?
}

// MARK: - All specific properties container for this character

struct Container: Decodable {
    let items: [Item]
}

// MARK: - Specific item for this character

struct Item: Decodable {
    let name: String
}
