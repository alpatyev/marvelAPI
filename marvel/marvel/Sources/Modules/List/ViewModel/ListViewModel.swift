import Foundation
import RxRelay
import RxSwift

// MARK: - List view model

protocol ListViewModelProtocol {
    var itemsRelay: PublishRelay<[CharacterItem]> { get }
    func textFieldReturned(name text: String?)
    func selected(at indexPath: IndexPath)
}

// MARK: - List view model

final class ListViewModel: ListViewModelProtocol {
    
    // MARK: - Network service
    
    private let networkService = MarvelDataService()
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()
    private var items = [CharacterItem]() {
        didSet {
            print("didSet")
            itemsRelay.accept(items)
        }
    }
    
    // MARK: - Public properties
    
    var itemsRelay = PublishRelay<[CharacterItem]>()
    
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
//        networkService.getData(using: .getCharactersForName(name)) { result in
//            switch result {
//                case .data(let marvelData):
//                    if let result = marvelData.value as? [CharacterItem] {
//                        self.items = result
//                        self.updateImages()
//                    } else {
//                        print("not implemented")
//                    }
//                case .error(let marvelError):
//                    print(marvelError)
//            }
//        }
        
        networkService.getData(using: .getCharactersForName(name)) { result in
            switch result {
                case .success(let names):
                    // self.items = names
                    var newItems: [CharacterItem] = []
                    for name in names {
                        let newItem = CharacterItem(id: 0, name: name.name,
                                                    thumbnail: CharacterImage(path: ""),
                                                    imageData: nil)
                        newItems.append(newItem)
                    }
                    self.items = newItems
                    // self.updateImages()
                case .failure(let error):
                    print(error)
            }
        }
    }
    
//    private func updateImages() {
//        for (index, value) in items.enumerated() {
//            updateImage(at: index, with: value.thumbnail.path)
//        }
//    }
    
//    private func updateImage(at index: Int, with path: String) {
//        networkService.getData(using: .getImageWith(url: path, type: .small)) { [weak self] result in
//            switch result {
//                case .data(let data):
//                    if let imageData = data.value as? Data {
//                        self?.items[index].imageData = imageData
//                    }
//                case .error(let description):
//                    print(description, path)
//            }
//        }
//    }
}
