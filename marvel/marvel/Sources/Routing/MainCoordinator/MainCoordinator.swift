import Foundation
import UIKit

// MARK: - Marvel Coordinator

class ApplicationCoordinator {

    private var navigationController: UINavigationController
    
    init(_ navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func start() {
        presentMarvelListScene()
    }
    
    public func presentMarvelListScene() {
        let listViewController = ListViewController()
        let listViewModel = ListViewModel()
        
        listViewController.configure(with: listViewModel)
        listViewModel.configure(with: self)
        
        navigationController.pushViewController(listViewController, animated: false)
    }
    
    public func presentMarvelDetailScene(model: SpecificCharacterModel, preview: Data?) {
        let detailViewController = DetailViewController()
        let detailViewModel = DetailViewModel()
        
        detailViewController.configure(with: detailViewModel)
        detailViewModel.configure(with: model, preview: preview, coordinator: self)
        
        navigationController.pushViewController(detailViewController, animated: false)
    }
}
