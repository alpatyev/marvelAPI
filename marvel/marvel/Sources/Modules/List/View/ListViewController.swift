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
        tableView.backgroundColor = Constants.Colors.black
        tableView.rx.setDelegate(self).disposed(by: bag)
        tableView.register(MarvelCell.self, forCellReuseIdentifier: MarvelCell.id)
        return tableView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.style = .whiteLarge
        indicator.hidesWhenStopped = true
        indicator.transform = CGAffineTransform.init(scaleX: 1.6, y: 1.6)
        return indicator
    }()
            
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ListViewModel()
        setupRx()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Setups
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupRx() {
        searchTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe { [weak self] next in
            self?.viewModel?.textFieldReturned(name: self?.searchTextField.text)
        }.disposed(by: bag)
    
        viewModel?.itemsRelay.asObservable()
            .bind(to: charactersList.rx
                    .items(cellIdentifier: MarvelCell.id, cellType: MarvelCell.self)) { _, item, cell in
                cell.configure(with: item.name, data: item.imageData)
        }.disposed(by: bag)
        
        charactersList.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.viewModel?.selected(at: indexPath)
            self?.charactersList.deselectRow(at: indexPath, animated: true)
        }).disposed(by: bag)
        
        viewModel?.messageRelay.asObservable().subscribe { [weak self] message in
            self?.statusMessage(message.element)
        }.disposed(by: bag)
        
        viewModel?.loadingRelay.asObservable()
            .bind(to: loadingIndicator.rx.isAnimating).disposed(by: bag)
    }
    
    private func setupView() {
        view.backgroundColor = .black
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
