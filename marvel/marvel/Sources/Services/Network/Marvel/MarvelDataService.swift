import Foundation
import Alamofire

// MARK: - Marvel data service

final class MarvelDataService {
    
    // MARK: - Builder object
    
    private let builder = MarvelURLBuilder()
    
    // MARK: - Main method
    
    func getData(using type: MarvelRequestType, completion: @escaping (MarvelResult) -> Void) {
        guard let url = builder.createURL(with: type) else {
            return completion(.error(.url("Wrong URL.")))
        }
        
        AF.request(url).response { [weak self] result in
            if let data = result.data, let pointer = self {
                return completion(pointer.serialize(with: type, from: data))
            } else {
                return completion(.error(.network("Something wrong with network service.")))
            }
        }
    }
    
    // MARK: - Private methods
    
    private func serialize(with type: MarvelRequestType, from data: Data) -> MarvelResult {
        do {
            let decoder = JSONDecoder()
            switch type {
                case .getCharactersForName(let name):
                    print("LOADED DATA FOR NAME \"\(name)\" : \(data.kilobytesString())")
                    
                    let decoded = try decoder.decode(MarvelResponseModel<MarvelDataModel<CharacterItem>>.self, from: data)
                    return checkedForAmount(of: decoded, sucess: .data(.characterList(decoded.data.results)))
                case .getCharacterForID(let id):
                    print("LOADED DATA FOR ID \"\(id)\" : \(data.kilobytesString())")
                    
                    let decoded = try decoder.decode(MarvelResponseModel<MarvelDataModel<SpecificCharacterModel>>.self, from: data)
                    return checkedForAmount(of: decoded, sucess: .data(.character(decoded.data.results[0])))
                case .getImageWith(_,_):
                    return .data(.image(data))
            }
        } catch let error {
            return .error(.data(error.localizedDescription))
        }
    }
    
    private func checkedForAmount<T>(of characters: MarvelResponseModel<MarvelDataModel<T>>,
                                     sucess: MarvelResult) -> MarvelResult {
        if characters.data.results.count > 0 {
            return sucess
        } else {
            return .error(.data("Not founded!"))
        }
    }
}
