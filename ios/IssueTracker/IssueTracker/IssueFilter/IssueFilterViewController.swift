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
    
    private var dataSource: UICollectionViewDiffableDataSource<Parent, DataItem>! = nil
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
    
    private func configureDataSource() {
        let headerRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Parent> { (cell, indexPath, item) in
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
        
        dataSource = UICollectionViewDiffableDataSource<Parent, DataItem>(collectionView: collectionView) { (collectionView, index, listItem) -> UICollectionViewCell? in
            switch listItem {
            case .parent(let parent):
                return collectionView.dequeueConfiguredReusableCell(using: headerRegistration, for: index, item: parent)
                
            case .child(let child):
                return collectionView.dequeueConfiguredReusableCell(using: childRegistration, for: index, item: child)
            }
        }
    }
    
    private func applySnapShot() {
        for parent in MockIdentifier.parents {
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
