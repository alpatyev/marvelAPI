import Foundation

// MARK: - Marvel URL builder

final class MarvelURLBuilder {    
    
    // MARK: - Private properties
    
    private let publicKey = "cf84e95c6735b5f2cebe6583497d937d"
    private let privateKey = "e62bc278ee244cf43225a6279cd0895ebf5c97d2"
    
    private lazy var components: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.port = 443
        components.path = "/v1/public/characters"
        return components
    }()
    
    // MARK: - Public methods
    
    public func createURL(with type: MarvelRequestType) -> URL? {
        switch type {
            case .getCharactersForName(let name):
                components.path = "/v1/public/characters"
                components.queryItems = [URLQueryItem(name: "nameStartsWith", value: name)] + createTodayQuery()
            case .getCharacterForID(let int):
                components.path = "/v1/public/characters/\(int)"
                components.queryItems = createTodayQuery()
            case .getImageWith(let url, let imageType):
                return URL(string: "https" + url.dropFirst(4) + "/" + imageType.option + ".jpg")
        }
        return components.url
    }
    
    // MARK: - Private methods
    
    private func createTodayQuery() -> [URLQueryItem] {
        let todayDate = Date().asString(with: "yyyy.MM.dd")
        let todayHash = (todayDate + privateKey + publicKey).hashedUsingMD5()
        return [URLQueryItem(name: "ts", value: todayDate),
                URLQueryItem(name: "apikey", value: publicKey),
                URLQueryItem(name: "hash", value: todayHash)]
    }
}
