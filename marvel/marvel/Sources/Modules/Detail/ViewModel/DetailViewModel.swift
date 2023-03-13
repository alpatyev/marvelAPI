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
    private var characterModel: SpecificCharacterModel? {
        didSet {
            if let model = characterModel {
                characterSubject.onNext(model)
            }
        }
    }

    // MARK: - Configuration
    
    public func configure(with model: SpecificCharacterModel, preview: Data?, coordinator: ApplicationCoordinator) {
        var detailedModel = model
        detailedModel.imageData = preview
        characterModel = detailedModel
    }
    
    // MARK: - View input
    
    func viewAlreadyOnScreen() {
        guard let imageURL = characterModel?.thumbnail?.path else {
            return
        }
        
        networkService.getData(using: .getImageWith(url: imageURL,
                                                    type: .large)) { [weak self] result in
            switch result {
                case .data(let data):
                    if let imageData = data.value as? Data {
                        self?.characterModel?.imageData = imageData
                    }
                case .error(let error):
                    print(error.text)
            }
        }
    }
}
