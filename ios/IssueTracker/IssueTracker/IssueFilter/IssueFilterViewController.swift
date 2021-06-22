//
//  IssueFilterViewController.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/17.
//

import UIKit
import Combine

extension IssueFilterViewController: ViewControllerIdentifierable {
    
    static func create(_ viewModel: FilterViewModel?) -> IssueFilterViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? IssueFilterViewController else {
            return IssueFilterViewController()
        }
        vc.viewModel = viewModel
        return vc
    }

}

protocol IssueFilterViewControllerDelegate: AnyObject {
    func issueFilterViewControllerDidCancel()
    func issueFilterViewControllerDidSave()
    func issueFilterViewControllerDidDismiss()
}


class IssueFilterViewController: UIViewController {
    
    private var dataSource: UICollectionViewDiffableDataSource<Parent, DataItem>! = nil
    
    @IBOutlet private var collectionView: UICollectionView!
    private var viewModel: FilterViewModel!
    private var cancelBag = Set<AnyCancellable>()
    weak var delegate: IssueFilterViewControllerDelegate?
    
    private lazy var nav: UINavigationBar = {
        return UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
    }()
    
    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setTitle("취소", for: .normal)
        button.setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTouched(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setTitle("저장", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTouched(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        setNavigation()
        configureLayout()
        configureDataSource()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentationController?.delegate = self
        viewModel.indexPaths().forEach {
            collectionView.selectItem(at: $0, animated: false, scrollPosition: .left)
        }
    }
    
}


extension IssueFilterViewController {
    
    private func bind() {
        viewModel.fetchFilterList().receive(on: DispatchQueue.main)
            .sink { parents in
                self.applySnapShot(with: parents)
            }
            .store(in: &cancelBag)
        
        viewModel.fetchError().receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { error in
                print(error)
            }.store(in: &cancelBag)
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
        let headerRegistration = UICollectionView.CellRegistration<SectionListCell, Parent> { (cell, indexPath, item) in
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
            
            if !item.isStatus { cell.accessories = [.outlineDisclosure()] }
        }
        let childRegistration = UICollectionView.CellRegistration<FilterListCell,Child> { (cell, indexPath, item) in
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
    
    private func applySnapShot(with parents: [Parent]) {
        var snapshot = NSDiffableDataSourceSnapshot<Parent, DataItem>()
        snapshot.appendSections(parents)
        dataSource.apply(snapshot, animatingDifferences: false)
        
        for parent in parents {
            var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<DataItem>()
            
            let parentDataItem = DataItem.parent(parent)
            sectionSnapshot.append([parentDataItem])
            
            let childDataItemArray = parent.children.map { DataItem.child($0) }
            sectionSnapshot.append(childDataItemArray, to: parentDataItem)
            sectionSnapshot.expand([parentDataItem])
            
            dataSource.apply(sectionSnapshot, to: parent, animatingDifferences: false)
        }
    }
    
}


extension IssueFilterViewController: UICollectionViewDelegate, UIAdaptivePresentationControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.indexPaths().forEach {
            collectionView.deselectItem(at: $0, animated: false)
        }
        viewModel.select(index: indexPath)
        viewModel.indexPaths().forEach {
            collectionView.selectItem(at: $0, animated: false, scrollPosition: .left)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.deselect(index: indexPath)
    }

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewModel.indexPaths().forEach {
            collectionView.deselectItem(at: $0, animated: false)
        }
        viewModel.deselectAll()
        viewModel.setFilter()
        delegate?.issueFilterViewControllerDidDismiss()
    }
    
}


extension IssueFilterViewController {
    
    private func setNavigation() {
        view.addSubview(nav)
        let navItem = UINavigationItem(title: "필터")
        
        navItem.leftBarButtonItem = cancelButton
        navItem.rightBarButtonItem = saveButton
        
        nav.setItems([navItem], animated: false)
    }
    
    @objc func cancelButtonTouched(_ sender: UIBarButtonItem) {
        viewModel.indexPaths().forEach {
            collectionView.deselectItem(at: $0, animated: false)
        }
        viewModel.setFilter()
        delegate?.issueFilterViewControllerDidCancel()
    }
    
    @objc private func saveButtonTouched(_ sender: UIButton) {
        viewModel.setFilter()
        delegate?.issueFilterViewControllerDidSave()
    }
    
}
