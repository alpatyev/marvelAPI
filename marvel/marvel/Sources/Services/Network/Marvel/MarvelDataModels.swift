import Foundation

// MARK: - Common models of reponse

struct MarvelResponseModel<DataModel: Decodable>: Decodable {
    let data: DataModel
}

struct MarvelDataModel<Container: Decodable>: Decodable {
    let results: [Container]
}

struct MarvelCharacter: Decodable {
    
}

struct MarvelComics: Decodable {
    
}

