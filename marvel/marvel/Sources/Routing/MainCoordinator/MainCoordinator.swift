import Foundation
import UIKit

// MARK: - Main protocol

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var childrenCoordinators: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}

// MARK: - Marvel Coordinator

class ApplicationCoordinator: Coordinator {
    
    var parentCoordinator: Coordinator?
    var childrenCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(_ navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        presentMarvelListScene()
    }
    
    
    func presentMarvelListScene() {
        let listViewController = ListViewController()
        let listViewModel = ListViewModel()
        listViewModel.configure(with: self)
        listViewController.configure(with: listViewModel)
        navigationController.pushViewController(listViewController, animated: true)
    }
    func presentMarvelDetailScene() {
        navigationController.pushViewController(DetailViewController(), animated: true)
    }

}

