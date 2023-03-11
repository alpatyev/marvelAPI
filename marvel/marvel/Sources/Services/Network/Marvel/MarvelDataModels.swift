import Foundation

// MARK: - Common models

struct MarvelResponseModel<DataModel: Decodable>: Decodable {
    let data: DataModel
}

struct MarvelDataModel<Container: Decodable>: Decodable {
    let results: [Container]
}

// MARK: - Some specific main character data model

struct CharacterImage: Decodable {
    let path: String
}
