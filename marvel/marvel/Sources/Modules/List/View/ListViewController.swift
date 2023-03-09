import UIKit
import SnapKit
import Alamofire
import RxSwift
import RxCocoa

// MARK: - List view controller

final class ListViewController: UIViewController {
    
    // MARK: - View model
    
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
        view.backgroundColor = .darkGray
        print("assert")
    }
    
    private func setupHierarchy() {
        
    }
    
    private func setupLayout() {
        
    }
}
