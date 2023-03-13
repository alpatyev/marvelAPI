import Foundation
import RxRelay
import RxSwift

// MARK: - List view model

protocol ListViewModelProtocol {
    var loadingRelay: PublishRelay<Bool> { get }
    var messageRelay: PublishRelay<(String, String)> { get }
    var itemsRelay: PublishRelay<[CharacterItem]> { get }
    
    func textFieldReturned(name text: String?)
    func selected(at indexPath: IndexPath)
    func viewOnScreen()
}

// MARK: - List view model

final class ListViewModel: ListViewModelProtocol {
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()
    private let networkService = MarvelDataService()
    private var coordinator: ApplicationCoordinator?
    private var itemsStorage = [CharacterItem]() {
        didSet {
            itemsRelay.accept(itemsStorage)
        }
    }
    
    // MARK: - Public properties
    
    var loadingRelay = PublishRelay<Bool>()
    var messageRelay = PublishRelay<(String, String)>()
    var itemsRelay = PublishRelay<[CharacterItem]>()
    
    // MARK: - Configuration
    
    public func configure(with coordinator: ApplicationCoordinator) {
        self.coordinator = coordinator
    }
    
    // MARK: - View input
    
    func textFieldReturned(name text: String?) {
        guard let name = text, name != "" else {
            messageRelay.accept(("Sorry...", "Please, type name of character."))
            return
        }
        requestForCharactersWith(name: name.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    func selected(at indexPath: IndexPath) {
        requestForCharacterWith(id: itemsStorage[indexPath.row].id)
    }
    
    func viewOnScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            if let name = self?.itemsStorage.randomElement()?.name {
                if Int.random(in: 1...10) % 3 == 0 {
                    self?.messageRelay.accept(("Check it out!",
                                               "We have \(name) ⭐️"))
                }
            } else {
                self?.messageRelay.accept(("Welcome 👋",
                                           "You can find characters for specific name."))
            }
        }
    }
    
    // MARK: - Private methods
    
    private func requestForCharactersWith(name: String) {
        loadingRelay.accept(true)
        networkService.getData(using: .getCharactersForName(name)) { [weak self] result in
            defer { self?.loadingRelay.accept(false) }
            switch result {
                case .data(let marvelData):
                    if let models = marvelData.value as? [CharacterItem] {
                        self?.messageRelay.accept(("Look! 👀", "There are \(models.count) characters."))
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
        loadingRelay.accept(true)
        let characterItem = self.itemsStorage.first { $0.id == id }
        print("REQUEST FOR: \(characterItem?.name ?? "who")")
        networkService.getData(using: .getCharacterForID(id)) { [weak self] result in
            defer { self?.loadingRelay.accept(false) }
            switch result {
                case .data(let data):
                    if let specificModel = data.value as? SpecificCharacterModel {
                        self?.messageRelay.accept(("Loaded!","Character with ID: \(id)"))
                        self?.coordinator?.presentMarvelDetailScene(model: specificModel,
                                                                    preview: characterItem?.imageData)
                    }
                case .error(let marvelError):
                    self?.messageRelay.accept(("Error ⛔️", marvelError.text))
            }
        }
    }
}
