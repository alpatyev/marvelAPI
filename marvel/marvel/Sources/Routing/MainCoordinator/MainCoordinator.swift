import UIKit

// MARK: - Marvel Coordinator

class ApplicationCoordinator {
    
    // MARK: - Root controller

    private var navigationController: UINavigationController
    
    // MARK: - Init
    
    init(_ navigationController : UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - MarvelFlow
    
    func startMarvelFlow() {
        presentMarvelListScene()
    }
    
    func presentMarvelListScene() {
        let listViewController = ListViewController()
        let listViewModel = ListViewModel()
        
        listViewController.configure(with: listViewModel)
        listViewModel.configure(with: self)
        
        navigationController.pushViewController(listViewController, animated: false)
    }
    
    func presentMarvelDetailScene(model: SpecificCharacterModel, preview: Data?) {
        let detailViewController = DetailViewController()
        let detailViewModel = DetailViewModel()
        
        detailViewController.configure(with: detailViewModel)
        detailViewModel.configure(with: model, preview: preview, coordinator: self)
        
        navigationController.pushViewController(detailViewController, animated: false)
    }
}
