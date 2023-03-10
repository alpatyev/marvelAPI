import Foundation
// MARK: - Common marvel result type

enum MarvelResult {
    case data(MarvelData)
    case error(MarvelError)
}

// MARK: - Response types

enum MarvelData {
    case character(MarvelCharacter)
    case characterList([MarvelCharacter])
    case comicsList([MarvelComics])
    case image(Data)
}

// MARK: - Error types

enum MarvelError: Error {
    case url(String)
    case network(String)
    case data(String)
}



