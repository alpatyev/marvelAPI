import Foundation
import Alamofire

enum NetworkError: Error {
    case unableToComplete
    case invalidUrl
    case invalidData
    case invalidDecoding
}

struct MainModel: Decodable {
    let data: SecondModel
}

struct SecondModel: Decodable {
    let results: [MarvelName]
}

struct MarvelName: Decodable {
    let name: String
}

// MARK: - Marvel data service

final class MarvelDataService {
    
    // MARK: - Private properties
    
    private let builder = MarvelURLBuilder()
    
    // MARK: - Public methods
    
    func getData(using type: MarvelRequestType, completion: @escaping (Result<[MarvelName], NetworkError>) -> Void) {
        guard let url = builder.createURL(with: type) else {
            //return completion(.error(.url("Invalid url")))
            return completion(.failure(.invalidUrl))
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.unableToComplete))
                return
            }
            
            // response
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(MainModel.self, from: data)
                let results = decodedResponse.data
                let result = results.results
                completion(.success(result))
            } catch {
                completion(.failure(.invalidDecoding))
                return
            }
            
        }.resume()
        
//        AF.request(url).response { result in
//            DispatchQueue.main.async {
//                if let data = result.data {
//                    return completion(self.serialize(with: type, from: data))
//                } else {
//                    return completion(.error(.network("Data not recieved")))
//                }
//            }
//        }
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
                    let decoded = try decoder.decode(MarvelResponseModel<MarvelDataModel<CharacterItem>>.self, from: data)
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
