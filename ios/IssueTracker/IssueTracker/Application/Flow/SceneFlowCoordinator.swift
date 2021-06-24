import UIKit

protocol SceneFlowCoordinatorDependencies {
    func makeIssueListTabBarController(_ viewControllers: [UIViewController]) -> UITabBarController
    func makeIssueListNavigationController(_ action: IssueListViewControllerAction) -> UINavigationController
    func makeNewIssueViewController(_ action: NewIssueViewControllerAction) -> NewIssueViewController
    func makeIssueDetailViewController(_ issue: IssueDetail) -> IssueDetailViewController
}


class SceneFlowCoordinator {
    private weak var rootVC: UINavigationController?
    private var dependencies: SceneFlowCoordinatorDependencies
    private var issueListViewController: UINavigationController?
    
    init(_ rootViewController: UINavigationController, _ dependencies: SceneFlowCoordinatorDependencies) {
        self.rootVC = rootViewController
        self.dependencies = dependencies
    }
    
    func start() {
        let issueListVCAction = IssueListViewControllerAction(showNewIssueView: showNewIssueView, showIssueDetailView: showIssueDetailView(_:))
        issueListViewController = dependencies.makeIssueListNavigationController(issueListVCAction)
        guard let issueListViewController = issueListViewController else { return }
        let vc = dependencies.makeIssueListTabBarController([issueListViewController])
        rootVC?.setNavigationBarHidden(true, animated: false)
        rootVC?.pushViewController(vc, animated: true)
    }
    
    func showNewIssueView() {
        guard let issueListViewController = issueListViewController else { return }
        let action = NewIssueViewControllerAction(showIssueDetailView: showIssueDetailView(_:))
        let vc = dependencies.makeNewIssueViewController(action)
        issueListViewController.pushViewController(vc, animated: true)
    }
    
    func showIssueDetailView(_ issue: IssueDetail) {
        guard let issueListViewController = issueListViewController else { return }
        let vc = dependencies.makeIssueDetailViewController(issue)
        vc.hidesBottomBarWhenPushed = true
        issueListViewController.pushViewController(vc, animated: true)
    }
    
    func showIssueListView() {
        issueListViewController?.popToRootViewController(animated: true)
    }
}
