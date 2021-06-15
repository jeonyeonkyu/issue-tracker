//
//  IssueTrackerDIContainer.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/15.
//

import UIKit

class IssueTrackerDIContainer: SceneFlowCoordinatorDependencies {
    
    private func makeNetworkManager() -> NetworkManageable {
        return NetworkManager()
    }
    
    private func makeFetchIssueListUseCase() -> FetchIssueListUseCase {
        return DefaultFetchIssueListUseCase(networkManager: makeNetworkManager())
    }
    
    private func makeIssueListViewModel() -> IssueViewModel {
        return IssueViewModel(makeFetchIssueListUseCase())
    }
    
    private func makeIssueListViewController() -> IssueListViewController {
        return IssueListViewController.create(makeIssueListViewModel())
    }
    
    private func makeIssueListNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: makeIssueListViewController())
    }
    
    func makeIssueListTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [makeIssueListNavigationController()]
        return tabBarController
    }
    
    func makeSceneFlowCoordinator(_ rootViewController: UINavigationController) -> SceneFlowCoordinator {
        return SceneFlowCoordinator(rootViewController, self)
    }
    
}
