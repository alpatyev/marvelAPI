import Foundation

final class MarvelURLBuilder {
    
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
    
    public func getURLForRandom() -> URL? {
        components.queryItems = createTodayQuery(for: URLQueryItem(name: "name",
                                                                   value: "Spider-Man"))
        return components.url
    }
    
    private func createTodayQuery(for parameter: URLQueryItem) -> [URLQueryItem] {
        let todayDate = Date().asString(with: "yyyy.MM.dd")
        let todayHash = (todayDate + privateKey + publicKey).hashedUsingMD5()
        
        return [parameter,
                URLQueryItem(name: "ts", value: todayDate),
                URLQueryItem(name: "apikey", value: publicKey),
                URLQueryItem(name: "hash", value: todayHash)]
    }
}
