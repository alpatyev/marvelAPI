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
        viewModel?.characterRelay.asObservable().subscribe { model in
            print(model.element?.name ?? "? name")
        }.disposed(by: bag)
    }
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setupHierarchy() {
    }
    
    private func setupLayout() {
    
    }
}
