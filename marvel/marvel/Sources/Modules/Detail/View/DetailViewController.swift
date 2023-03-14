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
        let button = GradientButton(gradientColors: [.red, .blue, .purple, .red])
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitle("select category", for: .normal)
        button.titleLabel?.font = Constants.Fonts.header
        return button
    }()
    
    
    private lazy var infoLabel: UILabel = {
        let label = GradientLabel()
        label.makeTextColorGradient()
        label.font = Constants.Fonts.monospaced
        label.textAlignment = .left
        label.numberOfLines = 0
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
        
        propertiesButton.rx.controlEvent(.touchUpInside)
            .throttle(.milliseconds(100), scheduler: MainScheduler.instance)
            .debounce(.milliseconds(150), scheduler: MainScheduler.instance)
            .subscribe { [weak self] _ in
            self?.viewModel?.menuButtonTapped()
        }.disposed(by: bag)
        
        viewModel?.propertiesRelay.subscribe { [weak self] event in
            self?.infoLabel.text = event.element
        }.disposed(by: bag)
        
        viewModel?.propertiesMessageRelay.subscribe(onNext: { [weak self] options in
            self?.statusMessage(options)
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
        scrollContentView.addSubview(infoLabel)
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
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(Constants.Layout.defaultHeight)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(propertiesButton.snp.bottom).offset(Constants.Layout.indent)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(400)
        }
    }
    
    // MARK: - Selectable property alert

    private func statusMessage(_ source: [String]?) {
        guard let options = source else { return }
                
        let backgroundColor = EKColor(Constants.Colors.black.withAlphaComponent(0.75))
        let mainColor = EKColor(Constants.Colors.main)
        let whiteColor = EKColor(Constants.Colors.white)
        let highlightedColor = EKColor(Constants.Colors.white.withAlphaComponent(0.5))
                
        var attributes = EKAttributes.bottomNote
        attributes.entryInteraction = .absorbTouches
        attributes.entryBackground = .color(color: backgroundColor)
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.displayDuration = .infinity
        
        var headerLabelStyle = EKProperty.LabelStyle(font: .systemFont(ofSize: 34),
                                                     color: whiteColor)
        headerLabelStyle.alignment = .center
        
        let buttonLabelStyle = EKProperty.LabelStyle(font: .systemFont(ofSize: 24),
                                                     color: mainColor)
        let firstHeader = EKProperty.LabelContent(text: "categories:",
                                                  style: headerLabelStyle)
        let secondHeader = EKProperty.LabelContent(text: "",
                                                   style: headerLabelStyle)

        
        var contents = [EKProperty.ButtonContent]()
        
        for (i, text) in options.enumerated() {
            let label = EKProperty.LabelContent(text: text, style: buttonLabelStyle)
            let button = EKProperty.ButtonContent(label: label,
                                                  backgroundColor: .clear,
                                                  highlightedBackgroundColor: highlightedColor) {
                SwiftEntryKit.dismiss { [weak self] in
                    self?.viewModel?.selectedProperty(at: i)
                }
            }
            contents.append(button)
        }
       

        let buttonsBarContent = EKProperty.ButtonBarContent(with: contents,
                                                            separatorColor: .clear,
                                                            expandAnimatedly: true)
        let simpleMessage = EKSimpleMessage(title: firstHeader,
                                            description: secondHeader)
        let message = EKAlertMessage(simpleMessage: simpleMessage,
                                     buttonBarContent: buttonsBarContent)
        let contentView = EKAlertMessageView(with: message)
        
        SwiftEntryKit.dismiss(.all)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}
