import UIKit
import SnapKit
import Alamofire
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
        let service = MarvelURLBuilder()
        print(service.createURL(with: .getCharacterForID(1011334))!)
        print(service.createURL(with: .getCharactersForName("3-D Man"))!)
        print(service.createURL(with: .getComicsForCharacterName("3-D Man"))!)
        print(service.createURL(with: .getImageWith(url: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784", type: .large))!)
    }
}
