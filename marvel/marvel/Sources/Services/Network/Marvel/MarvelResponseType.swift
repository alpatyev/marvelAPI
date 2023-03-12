import Foundation

// MARK: - Common marvel result type

enum MarvelResult {
    case data(MarvelData)
    case error(MarvelError)
}

// MARK: - Response types

enum MarvelData {
    case character(SpecificCharacterModel)
    case characterList([CharacterItem])
    case comicsList([MarvelComics])
    case image(Data)
    
    var value: Any {
        switch self {
            case .character(let marvelCharacter):
                return marvelCharacter
            case .characterList(let list):
                return list
            case .comicsList(let list):
                return list
            case .image(let data):
                return data
        }
    }
}

// MARK: - Error types

enum MarvelError: Error {
    case url(String)
    case network(String)
    case data(String)
    
    var text: String {
        switch self {
            case .url(_):
                return "Something went wrong!"
            case .network(let string):
                return string
            case .data(let string):
                return string
        }
    }
}
