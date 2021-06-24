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
    func makeIssueFilterViewController() -> IssueFilterViewController
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
        let issueListVCAction = IssueListViewControllerAction(showNewIssueView: showNewIssueView, showFilterView: showFilterView)
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
    
    func showFilterView() {
        guard let issueListViewController = issueListViewController else { return }
        let vc = dependencies.makeIssueFilterViewController()
        vc.delegate = issueListViewController.topViewController as? IssueListViewController
        issueListViewController.present(vc, animated: true, completion: nil)
    }
}
