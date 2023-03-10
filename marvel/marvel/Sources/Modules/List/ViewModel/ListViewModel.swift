import Foundation

// MARK: - List view model

protocol ListViewModelProtocol {
    func textFieldReturned(name text: String?)
}

// MARK: - List view model

final class ListViewModel: ListViewModelProtocol {
    
    // MARK: - Network service
    
    private let networkService = MarvelDataService()
    
    // MARK: - Private properties
    
    // MARK: - View input
    
    func textFieldReturned(name text: String?) {
        guard let name = text, name != "" else {
            print("pass name ")
            return
        }
        networkService.getData(using: .getCharactersForName(name), completion: { result in
            print(result)
        })
    }
    
    // MARK: - Private methods
}
