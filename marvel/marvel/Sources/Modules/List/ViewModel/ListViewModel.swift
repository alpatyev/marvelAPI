import Foundation
import RxRelay

// MARK: - List view model

protocol ListViewModelProtocol {
    var items: BehaviorRelay<[CharacterItem]> { get }
    func textFieldReturned(name text: String?)
}

// MARK: - List view model

final class ListViewModel: ListViewModelProtocol {
    
    // MARK: - Network service
    
    private let networkService = MarvelDataService()
    
    // MARK: - Private properties
    
    // MARK: - Public properties
    
    var items = BehaviorRelay<[CharacterItem]>(value: [Constants.Mock.emptyItem])
    
    // MARK: - Lifecycle
    
    init() {
        
    }
    
    // MARK: - View input
    
    func textFieldReturned(name text: String?) {
        guard let name = text, name != "" else {
            print("pass name ")
            return
        }
        requestForCharactersWith(name: name)
        
    }
    
    // MARK: - Private methods
    
    private func requestForCharactersWith(name: String) {
        networkService.getData(using: .getCharactersForName(name), completion: { result in
            switch result {
                case .data(let marvelData):
                    if let result = marvelData.value as? [CharacterItem] {
                        print(result)
                        self.items.accept(result)
                        
                    } else {
                        print("not implemented")
                    }
                case .error(let marvelError):
                    print(marvelError)
            }
        })
    }
}
