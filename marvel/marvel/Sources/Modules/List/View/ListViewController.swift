import UIKit
import SnapKit
import RxSwift
import RxCocoa

// MARK: - List view controller

final class ListViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK: - View model
    
    private var viewModel: ListViewModelProtocol?
    
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
        tableView.backgroundColor = Constants.Colors.black
        tableView.rx.setDelegate(self).disposed(by: bag)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    private lazy var bag = DisposeBag()

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
    
        viewModel?.items.asObservable()
            .bind(to: charactersList.rx
                    .items(cellIdentifier: "cell", cellType: UITableViewCell.self))
        { index, element, cell in
            cell.backgroundColor = Constants.Colors.tint
            cell.textLabel?.textColor = Constants.Colors.main
            cell.textLabel?.text = element.name
            cell.imageView?.image = UIImage(systemName: "circle")
            cell.accessoryType = .disclosureIndicator
            cell.layer.cornerRadius = Constants.Layout.cornerRadius / 2
        }.disposed(by: bag)
        
        charactersList.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
                self?.charactersList.deselectRow(at: indexPath, animated: true)
                print(indexPath)
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
