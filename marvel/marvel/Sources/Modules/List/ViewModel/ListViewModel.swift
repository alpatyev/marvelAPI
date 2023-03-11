import Foundation
import RxRelay
import RxSwift

// MARK: - List view model

protocol ListViewModelProtocol {
    var items: PublishRelay<[CharacterItem]> { get }
    var images: PublishRelay<[Data]> { get }
    func textFieldReturned(name text: String?)
    func selected(at indexPath: IndexPath)
}

// MARK: - List view model

final class ListViewModel: ListViewModelProtocol {
    
    // MARK: - Network service
    
    private let networkService = MarvelDataService()
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()

    // MARK: - Public properties
    
    var items = PublishRelay<[CharacterItem]>()
    var images = PublishRelay<[Data]>()
    
    // MARK: - Lifecycle
    
    init() {
        items.sub
    }
    
    // MARK: - View input
    
    func textFieldReturned(name text: String?) {
        guard let name = text, name != "" else {
            print("pass name ")
            return
        }
        requestForCharactersWith(name: name)
    }
    
    func selected(at indexPath: IndexPath) {
        print("Selected at: \(indexPath.row)")
    }
    
    // MARK: - Private methods
    
    private func requestForCharactersWith(name: String) {
        networkService.getData(using: .getCharactersForName(name), completion: { result in
            switch result {
                case .data(let marvelData):
                    if let result = marvelData.value as? [CharacterItem] {
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
