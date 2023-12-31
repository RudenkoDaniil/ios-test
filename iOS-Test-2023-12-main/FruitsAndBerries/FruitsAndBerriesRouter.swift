//
//  FruitsAndBerriesRouter.swift
//  iOS-Test
//

import UIKit

protocol FruitsAndBerriesRoutingLogic {
    func navigateToDetails(item: FruitsAndBerriesModels.Load.ViewModel.Item)
}

class FruitsAndBerriesRouter {
    weak var controller: FruitsAndBerriesViewController?
}

extension FruitsAndBerriesRouter: FruitsAndBerriesRoutingLogic {
    func navigateToDetails(item: FruitsAndBerriesModels.Load.ViewModel.Item) {
        // Push the details screen into the navigation controller
        let detailsViewController = FruitsAndBerriesDetailsViewController()
        detailsViewController.item = item
        
        let navVC = UINavigationController(rootViewController: detailsViewController)
        controller?.interactor?.loadDetails(request: FruitsAndBerriesModels.LoadDetails.Request(itemId: item.id)) { [weak self] detailsResponse in
            guard let self = self else { return }
            detailsViewController.descriptionItem = detailsResponse
            controller?.presentCustomDismissible(navVC, animated: true)
        }
        
    }
}

extension FruitsAndBerriesRouter {
    static func createModule() -> FruitsAndBerriesViewController {
        let controller = UIStoryboard(name: "FruitsAndBerries", bundle: nil)
            .instantiateViewController(withIdentifier: "FruitsAndBerriesViewController") as! FruitsAndBerriesViewController
        let interactor = FruitsAndBerriesInteractor()
        let presenter = FruitsAndBerriesPresenter()
        let router = FruitsAndBerriesRouter()
        
        controller.interactor = interactor
        controller.router = router
        interactor.presenter = presenter
        presenter.view = controller
        router.controller = controller
        
        return controller
    }
}
