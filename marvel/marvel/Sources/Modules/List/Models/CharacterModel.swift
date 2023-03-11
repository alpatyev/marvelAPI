import Foundation

// MARK: - Character model

struct CharacterItem: Decodable {
    let id: Int
    let name: String
    let thumbnail: CharacterImage
    var imageData: Data?
}

struct CharacterImage: Decodable {
    let path: String
}
