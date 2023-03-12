import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftEntryKit

// MARK: - Detail view controller

final class DetailViewController: UIViewController {
    
    // MARK: - View model
    
    private var viewModel: DetailViewModelProtocol?
    
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
    
    // MARK: - Setups
    
    private func setupRx() {
        
    }
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    private func setupHierarchy() {
    }
    
    private func setupLayout() {
    
    }
}
