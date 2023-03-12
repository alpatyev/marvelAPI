import Foundation
import RxRelay
import RxSwift

// MARK: - List view model

protocol ListViewModelProtocol {
    var messageRelay: PublishRelay<(String, String)> { get }
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
    private var itemsStorage = [CharacterItem]() {
        didSet {
            itemsRelay.accept(itemsStorage)
        }
    }

    // MARK: - Public properties
    
    var messageRelay = PublishRelay<(String, String)>()
    var itemsRelay = PublishRelay<[CharacterItem]>()
    
    // MARK: - View input
    
    func textFieldReturned(name text: String?) {
        guard let name = text, name != "" else {
            messageRelay.accept(("Sorry...", "Please, type name of character."))
            return
        }
        requestForCharactersWith(name: name)
    }
    
    func selected(at indexPath: IndexPath) {
        print("Selected at: \(indexPath.row)")
    }
    
    // MARK: - Private methods
    
    private func requestForCharactersWith(name: String) {
        networkService.getData(using: .getCharactersForName(name)) { [weak self] result in
            switch result {
                case .data(let marvelData):
                    if let models = marvelData.value as? [CharacterItem] {
                        self?.messageRelay.accept(("Look!", "There are \(models.count) characters."))
                        self?.itemsStorage = models
                        self?.downloadItemImages()
                    }
                case .error(let marvelError):
                    self?.messageRelay.accept(("Error ⛔️", marvelError.text))
            }
        }
    }
    
    private func downloadItemImages() {
        for index in 0..<itemsStorage.count {
            loadImageDataForItem(at: index)
        }
    }
    
    private func loadImageDataForItem(at index: Int) {
        networkService.getData(using: .getImageWith(url: itemsStorage[index].thumbnail.path,
                                                    type: .small)) { [weak self] result in
            switch result {
                case .data(let data):
                    if let imageData = data.value as? Data {
                        print("IMG \(index) LOADED: \(imageData.debugDescription)")
                        self?.itemsStorage[index].imageData = imageData
                    } else {
                        print("IMG \(index) DATA ERROR")
                    }
                case .error(let marvelError):
                    print("IMG \(index) ERROR: \(marvelError.localizedDescription)")
            }
        }
    }
    
    private func requestForCharacterWith(id: Int) {
        networkService.getData(using: .getCharacterForID(id)) { [weak self] result in
            
        }
    }
}
