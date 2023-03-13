import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftEntryKit

// MARK: - Detail view controller

final class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - View model
    
    private var viewModel: DetailViewModelProtocol?
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()
    private let selectedIndex = PublishRelay<Int>()
    
    // MARK: - UI
    
    private lazy var scrollContentView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.bounces = true
        scrollView.contentSize = CGSize(width: view.frame.size.width,
                                        height: 1000)
        scrollView.showsVerticalScrollIndicator = false
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
    
    
    private lazy var propertiesButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Constants.Colors.hardTint
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        return button
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
        scrollContentView.addSubview(propertiesButton)
    }
    
    private func setupLayout() {
        scrollContentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.centerX.equalToSuperview()
            make.width.height.equalToSuperview()
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
        
        propertiesButton.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.Layout.indent)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(Constants.Layout.defaultHeight)
        }
    }
    
    // MARK: - Selectable property alert

    @objc private func tapped() {
        statusMessage([String]())
    }
    
    
    let backgroundColor = EKColor.init(Constants.Colors.black.withAlphaComponent(0.5))
    let mainColor = EKColor.init(Constants.Colors.main)
    
    private func statusMessage(_ source: [String]?) {
        guard let _ = source else { return }
        
        var attributes = EKAttributes.bottomNote
        attributes.entryInteraction = .absorbTouches
        attributes.entryBackground = .color(color: backgroundColor)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 10), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.positionConstraints.verticalOffset = Constants.Layout.indent
        attributes.border = EKAttributes.Border.value(color: Constants.Colors.main,
                                                      width: Constants.Layout.borderWidth)
        
        showAlertView(attributes: attributes)
    
    }
    
    private func showAlertView(attributes: EKAttributes) {
        
        // Ok Button
        let okButtonLabelStyle = EKProperty.LabelStyle(font: .systemFont(ofSize: 12), color: mainColor)
        let okButtonLabel = EKProperty.LabelContent(text: "OK, ACCEPT", style: okButtonLabelStyle)
        let okButton = EKProperty.ButtonContent(label: okButtonLabel, backgroundColor: .clear, highlightedBackgroundColor:  mainColor) {
            SwiftEntryKit.dismiss {
                print("okButton")
            }

        }

        let buttonsBarContent = EKProperty.ButtonBarContent(
            with: okButton, okButton,
            separatorColor: mainColor,
            displayMode: .dark,
            expandAnimatedly: true
        )
        let alertMessage = EKAlertMessage(simpleMessage: EKSimpleMessage(title: okButtonLabel,
                                                                         description: okButtonLabel), buttonBarContent: buttonsBarContent)
        let contentView = EKAlertMessageView(with: alertMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
