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
    
    private func makeFetchIssueDetailUseCase() -> FetchIssueDetailUseCase {
        return DefaultFetchIssueDetailUseCase(networkManager: networkManager)
    }
    
    private func makeFetchFilterUseCase() -> FetchFilterUseCase {
        return DefaultFetchFilterUseCase(networkManager: networkManager)
    }
    
    private func makeIssueListViewModel() -> IssueViewModel {
        return IssueViewModel(makeFetchIssueListUseCase(), filterUseCase, makeFetchIssueDetailUseCase())
    }
    
    private func makeFilterViewModel() -> FilterViewModel {
        return FilterViewModel(makeFetchFilterUseCase(), filterUseCase)
    }
    
    private func makeIssueListViewController(_ action: IssueListViewControllerAction) -> IssueListViewController {
        let viewModel = makeIssueListViewModel()
        let dataSource = IssueDataSource(viewModel: viewModel)
        return IssueListViewController.create(viewModel, dataSource, action)
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

//MARK: - NewIssue ViewController

extension IssueTrackerDIContainer {
    private func makePostNewIssueUseCase() -> PostNewIssueUseCase {
        return DefaultPostNewIssueUseCase(networkManager)
    }
    
    private func makeFetchFilterSectionsUseCase() -> FetchFilterSectionsUseCase {
        return DefaultFetchFilterSectionsUseCase(networkManager)
    }
    
    private func makePostImageFileUseCase() -> UploadImageUseCase {
        return DefaultUploadImageUseCase(networkManager)
    }
    
    private func makeNewIssueViewModel() -> NewIssueViewModel {
        return NewIssueViewModel(makeFetchFilterSectionsUseCase() ,makePostNewIssueUseCase(), makePostImageFileUseCase())
    }
    
    private func makeMarkdownViewController(_ viewModel: NewIssueViewModel) -> MarkdownViewController {
        return MarkdownViewController.create(viewModel)
    }
    
    private func makePreviewViewController() -> PreviewViewController {
        return PreviewViewController.create()
    }
    
    func makeNewIssueViewController(_ action: NewIssueViewControllerAction) -> NewIssueViewController {
        let viewModel = makeNewIssueViewModel()
        return NewIssueViewController.create(viewModel, makeMarkdownViewController(viewModel), makePreviewViewController(), action)
    }
}

//MARK: - IssueDetail ViewController

extension IssueTrackerDIContainer {
    
    private func makeIssueDetailViewModel(_ issue: IssueDetail) -> IssueDetailViewModel {
        return IssueDetailViewModel.init(issue: issue)
    }
    
    func makeIssueDetailViewController(_ issue: IssueDetail) -> IssueDetailViewController {
        return IssueDetailViewController.create(makeIssueDetailViewModel(issue))
    }
}
