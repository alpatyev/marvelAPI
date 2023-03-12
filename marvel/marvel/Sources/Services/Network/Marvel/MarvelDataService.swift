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
            DispatchQueue.main.async {
                if let data = result.data {
                    return completion(self.serialize(with: type, from: data))
                } else {
                    return completion(.error(.network("Data not recieved")))
                }
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
                    return checkedForAmount(of: decoded, .data(.comicsList(decoded.data.results)))
                case .getCharactersForName(_):
                    let decoded = try decoder.decode(MarvelResponseModel<MarvelDataModel<CharacterItem>>.self, from: data)
                    return checkedForAmount(of: decoded, .data(.characterList(decoded.data.results)))
                case .getCharacterForID(_):
                    let decoded = try decoder.decode(MarvelResponseModel<MarvelDataModel<SpecificCharacterModel>>.self, from: data)
                    if let character = decoded.data.results.first {
                        return .data(.character(character))
                    } else {
                        return .error(.data("Character with exact ID does not exist"))
                    }
                case .getImageWith(_, _):
                    return .data(.image(data))
            }
        } catch let error {
            return .error(.data(error.localizedDescription))
        }
    }
    
    private func checkedForAmount<T>(of characters: MarvelResponseModel<MarvelDataModel<T>>, _ sucess: MarvelResult) -> MarvelResult {
        if characters.data.results.count > 0 {
            return sucess
        } else {
            return .error(.data("Not founded!"))
        }
    }
}
