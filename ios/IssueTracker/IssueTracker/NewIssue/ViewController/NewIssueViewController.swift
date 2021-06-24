//
//  NewIssueViewController.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/18.
//

import UIKit
import Combine

struct NewIssueViewControllerAction {
    let showIssueDetailView: (IssueDetail) -> Void
}

final class NewIssueViewController: UIViewController, ViewControllerIdentifierable {
    
    static func create(_ viewModel: NewIssueViewModel, _ markdownViewController: MarkdownViewController, _ previewViewController: PreviewViewController, _ action: NewIssueViewControllerAction) -> NewIssueViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? NewIssueViewController else {
            return NewIssueViewController()
        }
        vc.viewModel = viewModel
        vc.action = action
        vc.markdownViewController = markdownViewController
        vc.previewViewController = previewViewController
        return vc
    }
    
    @IBOutlet private var titleTextField: UITextField!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var filteringTableView: UITableView!
    
    private var viewModel: NewIssueViewModel!
    private var action: NewIssueViewControllerAction?
    private var markdownViewController: MarkdownViewController?
    private var previewViewController: PreviewViewController?
    private var cancelBag = Set<AnyCancellable>()
    private lazy var segmentControl = UISegmentedControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        bind()
    }
    
}

//MARK:- Set Inital Condition

extension NewIssueViewController {
    private func setting() {
        setNavigation()
        setTableView()
    }

    private func setNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setSegmentControl()
        setRightBarButtonItem()
        navigationItem.titleView = segmentControl
    }
    
    private func setSegmentControl() {
        let titles = ["Markdown", "Preview"]
        segmentControl = UISegmentedControl(items: titles)
        segmentControl.tintColor = UIColor.white
        segmentControl.backgroundColor =  #colorLiteral(red: 0.9097252488, green: 0.9059337974, blue: 0.9293009639, alpha: 1)
        segmentControl.selectedSegmentIndex = 0
        for index in 0...titles.count-1 {
            segmentControl.setWidth(100, forSegmentAt: index)
        }
        segmentControl.sizeToFit()
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.sendActions(for: .valueChanged)
    }
    
    private func setRightBarButtonItem() {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.addTarget(self, action: #selector(saveButtonTouched(_:)), for: .touchUpInside)
        button.tintColor = #colorLiteral(red: 0.6313168406, green: 0.6274867654, blue: 0.611690104, alpha: 1)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }

    private func setTableView() {
        filteringTableView.backgroundColor = view.backgroundColor
        filteringTableView.setEditing(true, animated: true)
        filteringTableView.allowsMultipleSelectionDuringEditing = true
    }

    private func bind() {
        viewModel.fetchFilteringSections().receive(on: DispatchQueue.main)
            .sink { issues in
                self.filteringTableView.reloadData()
            }
            .store(in: &cancelBag)
    }

    @objc func segmentChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
    @objc func saveButtonTouched(_ sender: UIButton) {
        guard let title = titleTextField.text, let comments = markdownViewController?.textView.text else { return }
        viewModel.saveNewIssue(title, comments) { [weak self] issueDetail in
            self?.action?.showIssueDetailView(issueDetail)
        }
    }
}

//MARK: - Segment Action

extension NewIssueViewController {
    private func add(asChildViewController viewController: UIViewController) {
        addChild(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        viewController.willMove(toParent: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
    
    private func updateView() {
        guard let previewViewController = previewViewController, let markdownViewController = markdownViewController else { return }
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: previewViewController)
            add(asChildViewController: markdownViewController)
        } else {
            remove(asChildViewController: markdownViewController)
            previewViewController.load(markdownViewController.textView.text)
            add(asChildViewController: previewViewController)
        }
    }
}

extension NewIssueViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.filteringSections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.filteringSections[section].collapsed {
            return 0
        }
        return viewModel.filteringSections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        
        content.text = viewModel.filteringSections[section].items[row].name
        cell.contentConfiguration = content
        cell.selectedBackgroundView = UIView()
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = FilteringHeader(title: viewModel.filteringSections[section].name)
        button.tag = section
        button.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: view.frame.width - 50, bottom: 0, right: 0)
        button.addTarget(self, action: #selector(handleExpandClose(_:)), for: .touchUpInside)
        
        return button
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        42
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        1
    }
    
    @objc func handleExpandClose(_ sender: UIButton) {
        let section = sender.tag
        var indexPaths = [IndexPath]()
        for row in viewModel.filteringSections[section].items.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let collapsed = viewModel.filteringSections[section].collapsed
        viewModel.changeCollapsed(with: section)
        
        if !collapsed {
            filteringTableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            filteringTableView.insertRows(at: indexPaths, with: .fade)
            filteringTableView.scrollToRow(at: indexPaths[0], at: .top, animated: true)
        }
        
        UIView.animate(withDuration: 0.2) {
            sender.imageView?.transform = CGAffineTransform(rotationAngle: !collapsed ? 0.0 : .pi / 2)
        }
    }
}
