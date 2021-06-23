//
//  IssueTrackerDIContainer.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/15.
//

import UIKit

final class IssueTrackerDIContainer: SceneFlowCoordinatorDependencies {
    
    private let networkManager = NetworkManager()
    private let filterUseCase = FilterUseCase()
    
    private func makeFetchIssueListUseCase() -> FetchIssueListUseCase {
        return DefaultFetchIssueListUseCase(networkManager: networkManager)
    }
    
    private func makeFetchFilterUseCase() -> FetchFilterUseCase {
        return DefaultFetchFilterUseCase(networkManager: networkManager)
    }
    
    private func makeIssueListViewModel() -> IssueViewModel {
        return IssueViewModel(makeFetchIssueListUseCase(), filterUseCase)
    }
    
    private func makeFilterViewModel() -> FilterViewModel {
        return FilterViewModel(makeFetchFilterUseCase(), filterUseCase)
    }
    
    private func makeIssueListViewController(_ action: IssueListViewControllerAction) -> IssueListViewController {
        return IssueListViewController.create(makeIssueListViewModel(), action)
    }
    
    func makeIssueFilterViewController() -> IssueFilterViewController {
        return IssueFilterViewController.create(makeFilterViewModel())
    }
    
    func makeIssueListNavigationController(_ action: IssueListViewControllerAction) -> UINavigationController {
        return UINavigationController(rootViewController: makeIssueListViewController(action))
    }
    
    func makeIssueListTabBarController(_ viewControllers: [UIViewController]) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        return tabBarController
    }
    
    func makeSceneFlowCoordinator(_ rootViewController: UINavigationController) -> SceneFlowCoordinator {
        return SceneFlowCoordinator(rootViewController, self)
    }
}
