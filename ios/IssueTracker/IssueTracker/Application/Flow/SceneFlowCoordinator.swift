import UIKit

protocol SceneFlowCoordinatorDependencies {
    func makeIssueListTabBarController(_ viewControllers: [UIViewController]) -> UITabBarController
    func makeIssueListNavigationController(_ action: IssueListViewControllerAction) -> UINavigationController
    func makeNewIssueViewController(_ action: NewIssueViewControllerAction) -> NewIssueViewController
    func makeIssueDetailViewController(_ issue: IssueDetail) -> IssueDetailViewController
    func makeIssueFilterViewController(_ isIssueListDelegate: Bool) -> IssueFilterViewController
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
        let issueListVCAction = IssueListViewControllerAction(showNewIssueView: showNewIssueView, showIssueDetailView: showIssueDetailView(_:), showFilterView: showFilterView(_:_:))
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
        guard let issueListViewController = issueListViewController else { return }
        let action = NewIssueViewControllerAction(showFilterView: showFilterView(_:_:), showIssueDetailView: showIssueDetailView(_:))
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
    
    func showFilterView(_ isIssueListDelegate: Bool, _ delegate: IssueFilterViewControllerDelegate) {
        guard let issueListViewController = issueListViewController else { return }
        let vc = dependencies.makeIssueFilterViewController(isIssueListDelegate)
        vc.delegate = delegate
        issueListViewController.present(vc, animated: true, completion: nil)
    }
}
