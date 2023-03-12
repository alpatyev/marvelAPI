import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftEntryKit

// MARK: - Detail view controller

final class DetailViewController: UIViewController {
    
    // MARK: - View model
    
    private var viewModel: DetailViewModelProtocol?
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()
    
    // MARK: - UI
    
    private lazy var characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.Layout.cornerRadius
        imageView.layer.borderWidth = Constants.Layout.borderWidth
        imageView.layer.borderColor = Constants.Colors.main.cgColor
        imageView.backgroundColor = Constants.Colors.hardTint
        return imageView
    }()
    
    // MARK: - Configuration
    
    public func configure(with viewModel: DetailViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRx()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.viewAlreadyOnScreen()
    }
    
    // MARK: - Setups
    
    private func setupRx() {
        viewModel?.characterSubject.subscribe({ [weak self] model in
            self?.title = model.element?.name
            guard let imageData = model.element?.imageData else { return }
            self?.characterImage.image = UIImage(data: imageData)

        }).disposed(by: bag)
    }
    
    private func setupView() {
        view.backgroundColor = Constants.Colors.black
    }
    
    private func setupHierarchy() {
        view.addSubview(characterImage)
    }
    
    private func setupLayout() {
        characterImage.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.Layout.defaultHeight)
            make.left.equalToSuperview().offset(Constants.Layout.defaultHeight)
            make.right.equalToSuperview().inset(Constants.Layout.defaultHeight)
            make.height.equalTo(characterImage.snp.width)
        }
    }
    
    // MARK: - Appearance methods
}
