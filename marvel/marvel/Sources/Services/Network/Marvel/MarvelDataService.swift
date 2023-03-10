import Foundation
import Alamofire

// MARK: - Marvel data service

final class MarvelDataService {
    
    // MARK: - Private properties
    
    private let builder = MarvelURLBuilder()
    
    // MARK: - Public methods
    
    public func getData(using type: MarvelRequestType, completion: @escaping (MarvelResult) -> Void) {
        guard let url = builder.createURL(with: type) else {
            return completion(.error(.url("Invalid url")))
        }
        
        AF.request(url).response(completionHandler: { result in
            if let data = result.data {
                return completion(self.serialize(with: type, from: data))
            } else {
                return completion(.error(.network("Data not recieved")))
            }
        })
    }
    
    // MARK: - Private methods
    
    private func serialize(with type: MarvelRequestType, from data: Data) -> MarvelResult {
        do {
            let decoder = JSONDecoder()
            switch type {
                case .getComicsForCharacterName(_):
                    let decoded = try decoder.decode(MarvelResponseModel<MarvelDataModel<MarvelComics>>.self, from: data)
                    return .data(.comicsList(decoded.data.results))
                case .getCharactersForName(_), .getCharacterForID(_):
                    let decoded = try decoder.decode(MarvelResponseModel<MarvelDataModel<MarvelCharacter>>.self, from: data)
                    
                    let list = decoded.data.results
                    if list.count > 1 {
                        return .data(.characterList(list))
                    } else {
                        if let one = list.first {
                            return .data(.character(one))
                        } else {
                            return .error(.data("Sorry, no characters are found"))
                        }
                    }
                case .getImageWith(_, _):
                    return .data(.image(data))
            }
        } catch let decodingError {
            return .error(.data(decodingError.localizedDescription))
        }
    }

}


