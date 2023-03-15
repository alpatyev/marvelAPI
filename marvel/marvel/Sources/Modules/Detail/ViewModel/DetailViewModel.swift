import Foundation
import RxSwift
import RxRelay

// MARK: - Detail view model protocol

protocol DetailViewModelProtocol {
    var characterSubject: ReplaySubject<SpecificCharacterModel> { get }
    var propertiesMessageRelay: PublishRelay<[String]> { get }
    var propertiesRelay: PublishRelay<String> { get }

    func viewAlreadyOnScreen()
    func menuButtonTapped()
    func selectedProperty(at index: Int)
}

// MARK: - Detail view model

final class DetailViewModel: DetailViewModelProtocol {
    
    // MARK: - Public properties
    
    var characterSubject = ReplaySubject<SpecificCharacterModel>.create(bufferSize: 1)
    var propertiesMessageRelay = PublishRelay<[String]>()
    var propertiesRelay = PublishRelay<String>()
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()
    private let networkService = MarvelDataService()
    private var coordinator: ApplicationCoordinator?
    private var characterInfo: CharacterInfo?
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
        characterInfo = CharacterInfo(using: detailedModel)
    }
    
    // MARK: - View input
    
    func viewAlreadyOnScreen() {
        guard let imageURL = characterModel?.thumbnail?.path else {
            return
        }
        
        networkService.getData(using: .getImageWith(url: imageURL,
                                                    type: .large)) { [weak self] result in
            defer { self?.selectedProperty(at: 0) }
            switch result {
                case .data(let data):
                    if let imageData = data.value as? Data {
                        print("LOADED IMG+ FOR ID \"\(self?.characterModel?.id ?? 0)\" : \(imageData.kilobytesString())")
                        self?.characterModel?.imageData = imageData
                    }
                case .error(let error):
                    print(error.text)
            }
        }
    }
    
    func menuButtonTapped() {
        if let options = characterInfo?.categories {
            propertiesMessageRelay.accept(options)
        }
    }
    
    func selectedProperty(at index: Int) {
        if let description = characterInfo?.descriptions[index] {
            propertiesRelay.accept(description)
        }
    }
}
