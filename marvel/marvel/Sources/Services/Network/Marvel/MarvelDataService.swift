import Foundation

// MARK: - Marvel data service

final class MarvelDataService {
    
    public func getRandomCharacters(amount: Int, completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}
