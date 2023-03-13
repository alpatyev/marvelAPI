import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - Detail view controller

final class DetailViewController: UIViewController {
    
    // MARK: - View model
    
    private var viewModel: DetailViewModelProtocol?
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()
    
    // MARK: - UI
    
    private lazy var scrollContentView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.contentSize = CGSize(width: view.frame.size.width * 0.9,
                                        height: 1000)
        return scrollView
    }()
        
    private lazy var characterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = Constants.Layout.cornerRadius
        imageView.layer.borderWidth = Constants.Layout.borderWidth
        imageView.layer.borderColor = Constants.Colors.main.cgColor
        imageView.backgroundColor = Constants.Colors.hardTint
        return imageView
    }()
    
    private lazy var nameLabel: GradientLabel = {
        let label = GradientLabel()
        label.font = .boldSystemFont(ofSize: 36)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        label.makeTextColorGradient()
        return label
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
            self?.nameLabel.text = model.element?.name
            
            if let imageData = model.element?.imageData {
                self?.characterImage.image = UIImage(data: imageData)
            } else {
                self?.characterImage.image = UIImage(named: "default")
            }
        }).disposed(by: bag)
    }
    
    private func setupView() {
        view.backgroundColor = Constants.Colors.black
    }
    
    private func setupHierarchy() {
        view.addSubview(scrollContentView)
        scrollContentView.addSubview(characterImage)
        scrollContentView.addSubview(nameLabel)
    }
    
    private func setupLayout() {
        scrollContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalToSuperview()
        }
        
        characterImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.Layout.indent)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(characterImage.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(characterImage.snp.bottom).offset(Constants.Layout.indent)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(Constants.Layout.defaultHeight)
        }
    }
    
    // MARK: - Appearance methods
}
