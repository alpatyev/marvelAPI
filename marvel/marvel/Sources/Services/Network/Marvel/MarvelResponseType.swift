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
    case image(Data)
    
    var value: Any {
        switch self {
            case .character(let marvelCharacter):
                return marvelCharacter
            case .characterList(let list):
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
            case .url(let message):
                return message
            case .network(let message):
                return message
            case .data(let message):
                return message
        }
    }
}
