import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - List view controller

final class ListViewController: UIViewController {
    
    // MARK: - View model
    
    // MARK: - UI
    
    private lazy var requestButton: UIButton = {
        let button = UIButton()
        button.setTitle("request", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.setTitleColor(.blue.withAlphaComponent(0.5), for: .highlighted)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setups
    
    private func setupRx() {
        
    }
    
    private func setupView() {
        view.backgroundColor = .black
        print("loaded list view")
    }
    
    private func setupHierarchy() {
        view.addSubview(requestButton)
    }
    
    private func setupLayout() {
        requestButton.snp.makeConstraints { make in
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(requestButton.snp.width).dividedBy(2)
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Actions
    
    @objc private func tapped() {
        print("tapped")
        MarvelDataService().getData(using: .getCharactersForName(""), completion: { result in
            switch result {
                case .data(let marvelData):
                    switch marvelData {
                        case .character(let marvelCharacter):
                            print(marvelCharacter)
                        case .characterList(let array):
                            for i in array {
                                print(i)
                            }
                        case .comicsList(let array):
                            for i in array {
                                print(i)
                            }
                        case .image(let data):
                            print(data.description)
                    }
                case .error(let marvelError):
                    switch marvelError {
                        case .url(let string):
                            print(string)
                        case .network(let string):
                            print(string)
                        case .data(let string):
                            print(string)
                    }
            }
        })
    }
}
