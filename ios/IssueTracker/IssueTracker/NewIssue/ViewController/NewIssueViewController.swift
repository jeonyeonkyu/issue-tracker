//
//  NewIssueViewController.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/18.
//

import UIKit
import Combine

struct NewIssueViewControllerAction {
    let showFilterView: (Bool, IssueFilterViewControllerDelegate) -> ()
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
    @IBOutlet private weak var filterView: UIView!
    
    private lazy var cancelButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.setTitle(" Back", for: .normal)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTouched(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 38, height: 18)
        button.setTitle("Save", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(saveButtonTouched(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
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
        setTextField()
        setNavigation()
        setFilterView()
    }
    
    private func setTextField() {
        titleTextField.delegate = self
        markdownViewController?.delegate = self
    }

    private func setNavigation() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        setSegmentControl()
        setBarButtonItems()
        navigationItem.titleView = segmentControl
    }
    
    private func setFilterView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(filterViewTouched(_:)))
        filterView.addGestureRecognizer(gesture)
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
    
    private func setBarButtonItems() {
        navigationItem.setHidesBackButton(true, animated: false)
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func cancelButtonTouched(_ sender: UIBarButtonItem) {
        viewModel.resetSavedIndex()
        navigationController?.popViewController(animated: true)
    }
    
}

extension NewIssueViewController {
    
    func bind() {
        viewModel.fetchIsSavealbe().receive(on: DispatchQueue.main)
            .sink { [weak self] isSaveable in
                self?.checkSaveButtonState(isSaveable)
            }.store(in: &cancelBag)
    }
    
}

//MARK: - Segment Action

extension NewIssueViewController {
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
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

//MARK: - Filtering Handling

extension NewIssueViewController: IssueFilterViewControllerDelegate {
    
    @objc func filterViewTouched(_ sender: UITapGestureRecognizer) {
        action?.showFilterView(false, self)
    }
    
    func issueFilterViewControllerDidCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func issueFilterViewControllerDidSave() {
        viewModel.filter()
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Save Button

extension NewIssueViewController: UITextFieldDelegate, TextAreaCheckableDelegate {
    
    func checkSaveButtonState(_ isSaveable: Bool) {
        saveButton.isEnabled = isSaveable
    }
    
    func checkTextArea() {
        guard let title = titleTextField.text, let comments = markdownViewController?.textView.text else { return }
        viewModel.checkSaveable(title, comments)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkTextArea()
        return true
    }
    
    @objc func saveButtonTouched(_ sender: UIButton) {
        guard let title = titleTextField.text, let comments = markdownViewController?.textView.text else { return }
        viewModel.saveNewIssue(title, comments) { [weak self] issueDetail in
            self?.action?.showIssueDetailView(issueDetail)
        }
    }
    
}
