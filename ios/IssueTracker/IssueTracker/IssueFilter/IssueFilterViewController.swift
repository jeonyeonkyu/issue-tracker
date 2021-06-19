//
//  IssueFilterViewController.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/17.
//

import UIKit

extension IssueFilterViewController: ViewControllerIdentifierable {
    
    static func create(_ viewModel: IssueViewModel?) -> IssueFilterViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? IssueFilterViewController else {
            return IssueFilterViewController()
        }
//        vc.viewModel = viewModel
        return vc
    }

}


class IssueFilterViewController: UIViewController {
    
    private struct Item: Hashable {
        let title: String?
        private let identifier = UUID()
    }
    
    // MARK: Identifier Types
    struct Parents: Hashable {
        let title: String
        let isStatus: Bool
        let children: [Child]
    }
    
    struct Child: Hashable {
        let title: String
        let id = UUID()
    }
    
    enum Status: String, CaseIterable {
        case written = "내가 작성한 이슈"
        case assigned = "나에게 할당된 이슈"
        case commented = "내가 댓글을 남긴 이슈"
        case opened = "열린 이슈"
        case closed = "닫힌 이슈"
    }
    
    enum DataItem: Hashable {
        case parent(Parents)
        case child(Child)
    }
    
    // MARK: Model objects
    let parents = [
        Parents(title: "상태", isStatus: true, children: Status.allCases.map { Child(title: $0.rawValue) }),
        Parents(title: "작성자", isStatus: false, children: [
            Child(title: "Dumba"),
            Child(title: "Lia"),
            Child(title: "Beemo"),
            Child(title: "Hiro"),
        ]),
        Parents(title: "레이블", isStatus: false, children: [
            Child(title: "Documentation"),
            Child(title: "bug"),
            Child(title: "iOS"),
            Child(title: "BE"),
        ]),
        Parents(title: "마일스톤", isStatus: false, children: [
            Child(title: "Filter"),
            Child(title: "NewIssue"),
            Child(title: "MockData"),
            Child(title: "OAuth"),
        ]),
    ]
    
    private var dataSource: UICollectionViewDiffableDataSource<Parents, DataItem>! = nil
    @IBOutlet private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configureDataSource()
        applySnapShot()
    }
    
}


extension IssueFilterViewController {

    private func configureLayout() {
        let appearance = UICollectionLayoutListConfiguration.Appearance.insetGrouped
        let layout = UICollectionViewCompositionalLayout { section, layoutEnvironment in
            var config = UICollectionLayoutListConfiguration(appearance: appearance)
            config.headerMode = .firstItemInSection
            return NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
        }
        collectionView.collectionViewLayout = layout
    }
}

extension IssueFilterViewController {
    
    private func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Parents> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            
            if !item.isStatus { cell.accessories = [.outlineDisclosure()] }
        }
        
        let childRegistration = UICollectionView.CellRegistration<UICollectionViewListCell,Child> { (cell, indexPath, item) in
            
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Parents, DataItem>(collectionView: collectionView) { (collectionView, index, listItem) -> UICollectionViewCell? in
            switch listItem {
            case .parent(let parent):
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: index, item: parent)
                
            case .child(let child):
                return collectionView.dequeueConfiguredReusableCell(using: childRegistration, for: index, item: child)
            }
        }
    }
    
    private func applySnapShot() {
        for parent in parents {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<DataItem>()
            
            let parentDataItem = DataItem.parent(parent)
            sectionSnapshot.append([parentDataItem])
            
            let childDataItemArray = parent.children.map { DataItem.child($0) }
            sectionSnapshot.append(childDataItemArray, to: parentDataItem)
            
            sectionSnapshot.expand([parentDataItem])
            dataSource.apply(sectionSnapshot, to: parent, animatingDifferences: true)
        }
    }
}
