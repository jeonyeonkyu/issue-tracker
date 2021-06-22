//
//  SceneFlowCoordinator.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/15.
//

import UIKit

protocol SceneFlowCoordinatorDependencies {
    func makeIssueListTabBarController(_ viewControllers: [UIViewController]) -> UITabBarController
    func makeIssueListNavigationController(_ action: IssueListViewControllerAction) -> UINavigationController
}


final class SceneFlowCoordinator {
    private weak var rootVC: UINavigationController?
    private var dependencies: SceneFlowCoordinatorDependencies
    private var issueListViewController: UINavigationController?
    
    init(_ rootViewController: UINavigationController, _ dependencies: SceneFlowCoordinatorDependencies) {
        self.rootVC = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let issueListVCAction = IssueListViewControllerAction(showNewIssueView: showNewIssueView)
        issueListViewController = dependencies.makeIssueListNavigationController(issueListVCAction)
        guard let issueListViewController = issueListViewController else { return }
        issueListViewController.setNavigationBarHidden(true, animated: false)
        let vc = dependencies.makeIssueListTabBarController([issueListViewController])
        vc.tabBar.isHidden = true
//        vc.tabBarController?.navigationController?.navigationBar.isHidden = true
//        vc.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: false)
//        vc.navigationController?.navigationBar.isHidden = true
        rootVC?.setNavigationBarHidden(true, animated: false)
        rootVC?.pushViewController(vc, animated: true)
    }
    
    func showNewIssueView() {
    }
}
