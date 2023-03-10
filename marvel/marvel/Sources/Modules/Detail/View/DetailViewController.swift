import UIKit

// MARK: - Detail view controller

final class DetailViewController: UIViewController {
    
    // MARK: - View model
    
    private let viewModel: ListViewModelProtocol? = nil
    
    // MARK: - UI
    
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
        print("loaded detail view")
    }
    
    private func setupHierarchy() {
    }
    
    private func setupLayout() {
    
    }
}
