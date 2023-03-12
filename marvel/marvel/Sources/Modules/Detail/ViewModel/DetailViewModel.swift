import Foundation
import RxSwift
import RxRelay


// MARK: - Detail view model protocol

protocol DetailViewModelProtocol {
    var characterSubject: ReplaySubject<SpecificCharacterModel> { get }
    var messageRelay: PublishRelay<String> { get }

    func viewAlreadyOnScreen()
}

// MARK: - Detail view model

final class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: - Public properties
    
    var characterSubject = ReplaySubject<SpecificCharacterModel>.create(bufferSize: 1)
    var messageRelay = PublishRelay<String>()
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()
    private let networkService = MarvelDataService()
    private var coordinator: ApplicationCoordinator?

    // MARK: - Configuration
    
    public func configure(with model: SpecificCharacterModel, preview: Data?, coordinator: ApplicationCoordinator) {
        var detailedModel = model
        detailedModel.imageData = preview
        characterSubject.onNext(detailedModel)
    }
    
    // MARK: - View input
    
    func viewAlreadyOnScreen() {

    }
}
