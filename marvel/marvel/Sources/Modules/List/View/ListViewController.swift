import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftEntryKit


// MARK: - List view controller

final class ListViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - View model
    
    private var viewModel: ListViewModelProtocol?
    
    // MARK: - Private properties
    
    private let bag = DisposeBag()
    
    // MARK: - UI
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = Constants.Layout.cornerRadius
        textField.layer.borderWidth = Constants.Layout.borderWidth
        textField.layer.borderColor = Constants.Colors.main.cgColor
        textField.backgroundColor = Constants.Colors.white
        textField.textColor = Constants.Colors.black
        textField.textAlignment = .center
        textField.font = Constants.Fonts.subheader
        textField.attributedPlaceholder = NSAttributedString(
            string: "search characters",
            attributes: [.foregroundColor: Constants.Colors.main.withAlphaComponent(0.5),
                         .font: Constants.Fonts.monospaced])
        textField.keyboardType = .asciiCapable
        textField.keyboardAppearance = .dark
        textField.returnKeyType = .google
        return textField
    }()
    
    private lazy var charactersList: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.rx.setDelegate(self).disposed(by: bag)
        tableView.backgroundColor = .clear
        tableView.register(MarvelCell.self, forCellReuseIdentifier: MarvelCell.id)
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .white
        indicator.hidesWhenStopped = true
        indicator.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        return indicator
    }()
    
    // MARK: - Configuration
    
    public func configure(with viewModel: ListViewModelProtocol) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.viewOnScreen()
        SwiftEntryKit.dismiss(.all)
    }
    
    // MARK: - Setups
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchTextField.resignFirstResponder()
        charactersList.isUserInteractionEnabled = true
        charactersList.layer.opacity = 1
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = Constants.Colors.black
        navigationController?.navigationBar.tintColor = Constants.Colors.main
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : Constants.Colors.main]
    }
    
    private func setupRx() {
        searchTextField.rx.controlEvent([.editingDidEndOnExit])
            .subscribe { [weak self] _ in
                self?.viewModel?.textFieldReturned(name: self?.searchTextField.text)
                self?.charactersList.isScrollEnabled = true
                self?.charactersList.layer.opacity = 1
            }.disposed(by: bag)
        
        searchTextField.rx.controlEvent([.editingDidBegin])
            .subscribe { [weak self] _ in
                self?.charactersList.isUserInteractionEnabled = false
                self?.charactersList.layer.opacity = 0.5
            }.disposed(by: bag)
    
        viewModel?.itemsRelay.asObservable()
            .bind(to: charactersList.rx
                    .items(cellIdentifier: MarvelCell.id,
                           cellType: MarvelCell.self)) { _, item, cell in
                cell.configure(with: item.name, data: item.imageData)
            }.disposed(by: bag)
        
        charactersList.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.viewModel?.selected(at: indexPath)
                self?.charactersList.deselectRow(at: indexPath, animated: true)
                self?.charactersList.isHidden = true
            }).disposed(by: bag)
        
        charactersList.rx.itemSelected
            .debounce(.milliseconds(700), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                self?.charactersList.isHidden = false
            }).disposed(by: bag)
        
        viewModel?.messageRelay
            .asObservable()
            .subscribe { [weak self] message in
                self?.statusMessage(message.element)
            }.disposed(by: bag)
        
        viewModel?.loadingRelay
            .asObservable()
            .bind(to: loadingIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel?.loadingRelay
            .asObservable()
            .bind(onNext: { [weak self] isLoading in
                self?.charactersList.isUserInteractionEnabled = isLoading
                self?.charactersList.layer.opacity = isLoading ? 0.5 : 1
            }).disposed(by: bag)
    }
    
    private func setupView() {
        title = "Search"
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.layer.opacity = 0.6
        backgroundImage.image = UIImage(named: "stars")
        backgroundImage.contentMode = .scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    private func setupHierarchy() {
        view.addSubview(searchTextField)
        view.addSubview(charactersList)
        view.addSubview(loadingIndicator)
    }
    
    private func setupLayout() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.Layout.indent)
            make.left.equalToSuperview().offset(Constants.Layout.indent / 2)
            make.right.equalToSuperview().inset(Constants.Layout.indent / 2)
            make.height.equalTo(Constants.Layout.defaultHeight)
        }
        
        charactersList.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(Constants.Layout.indent)
            make.left.equalToSuperview().offset(Constants.Layout.indent / 2)
            make.right.equalToSuperview().inset(Constants.Layout.indent / 2)
            make.bottom.equalToSuperview()
        }
    
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Alerts and status messages
    
    private func statusMessage(_ text: (String, String)?) {
        guard let message = text else { return }
        
        let backgroundColor = EKColor.init(Constants.Colors.white)
        let mainColor = EKColor.init(Constants.Colors.main)

        var attributes = EKAttributes.bottomFloat
        attributes.entryBackground = .color(color: backgroundColor)
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 4), scale: .init(from: 1, to: 0.7, duration: 0.7)))
        attributes.scroll = .enabled(swipeable: true, pullbackAnimation: .easeOut)
        attributes.positionConstraints.verticalOffset = Constants.Layout.indent
        attributes.border = EKAttributes.Border.value(color: Constants.Colors.main,
                                                      width: Constants.Layout.borderWidth)

        let title = EKProperty.LabelContent(text: message.0,
                                                style: .init(font: Constants.Fonts.subheader,
                                                             color: mainColor))
        let description = EKProperty.LabelContent(text: message.1,
                                                  style: .init(font: Constants.Fonts.subheader,
                                                               color: mainColor))
       
        let simpleMessage = EKSimpleMessage(title: title, description: description)
        let notificationMessage = EKNotificationMessage(simpleMessage: simpleMessage)

        let contentView = EKNotificationMessageView(with: notificationMessage)
        
        SwiftEntryKit.dismiss(.all)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
}

// MARK: - Setup cell size

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Layout.defaultHeight * 1.5
    }
}
