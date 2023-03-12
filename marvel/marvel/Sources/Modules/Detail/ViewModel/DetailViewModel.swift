import Foundation
import RxSwift
import RxRelay


// MARK: - Detail view model protocol

protocol DetailViewModelProtocol {
    var characterRelay: PublishRelay<SpecificCharacterModel> { get }
    var messageRelay: PublishRelay<String> { get }

    func viewAlreadyOnScreen()
    func tappedOnComics()
}

// MARK: - Detail view model

final class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: - Public properties
    
    var characterRelay = PublishRelay<SpecificCharacterModel>()
    var messageRelay = PublishRelay<String>()
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()
    private let networkService = MarvelDataService()
    private var coordinator: ApplicationCoordinator?

    // MARK: - Configuration
    
    public func configure(with model: SpecificCharacterModel, preview: Data?, coordinator: ApplicationCoordinator) {
        var detailedModel = model
        detailedModel.imageData = preview
        self.characterRelay.accept(detailedModel)
    }
    
    // MARK: - View input
    
    func viewAlreadyOnScreen() {
        print("view loaded > from viewmodel")
        fetchHDImage()
    }
    
    func tappedOnComics() {
        print("loadcomics")
        fetchComics()
    }
    
    // MARK: - Private methods
    
    private func fetchHDImage() {
        
    }
    
    private func fetchComics() {
        
    }
}
