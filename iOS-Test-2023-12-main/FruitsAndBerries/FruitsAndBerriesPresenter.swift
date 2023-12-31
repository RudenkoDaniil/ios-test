//
//  FruitsAndBerriesPresenter.swift
//  iOS-Test
//

// Implemented by View layer (ViewControllers)
protocol FruitsAndBerriesPresentationLogic {
    func present(response: FruitsAndBerriesModels.Load.Response)
}

class FruitsAndBerriesPresenter {
    weak var view: FruitsAndBerriesDisplayLogic?
}

extension FruitsAndBerriesPresenter: FruitsAndBerriesPresentationLogic {
    func present(response: FruitsAndBerriesModels.Load.Response) {
        let viewModel = FruitsAndBerriesModels.Load.ViewModel(items: response.items)
        view?.display(model: viewModel)
    }
}
