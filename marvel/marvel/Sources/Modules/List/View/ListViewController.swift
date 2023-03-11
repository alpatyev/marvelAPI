import UIKit
import SnapKit
import RxSwift
import RxCocoa

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
    
    private func setupRx() {
        searchTextField.rx.controlEvent([.editingDidEndOnExit]).subscribe { _ in
            self.viewModel?.textFieldReturned(name: self.searchTextField.text)
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
    }
    
    private func setupView() {
        view.backgroundColor = .black
        print("loaded list view")
    }
    
    private func setupHierarchy() {
        view.addSubview(searchTextField)
        view.addSubview(charactersList)
    }
    
    private func setupLayout() {
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.Layout.defaultHeight)
        }
        
        charactersList.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(Constants.Layout.indent)
            make.left.equalToSuperview().offset(Constants.Layout.indent / 2)
            make.right.equalToSuperview().inset(Constants.Layout.indent / 2)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Setup cell size

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.Layout.defaultHeight * 1.5
    }
}
