//
//  MarkdownViewController.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/18.
//

import UIKit

import Combine

final class MarkdownViewController: UIViewController, ViewControllerIdentifierable {
    
    static func create(_ viewModel: NewIssueViewModel) -> MarkdownViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? MarkdownViewController else {
            return MarkdownViewController()
        }
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet weak var textView: UITextView!
    
    private var viewModel: NewIssueViewModel!
    private var cancelBag = Set<AnyCancellable>()
    var delegate: TextAreaCheckableDelegate?
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setting()
        bind()
        
    }
    
}

//MARK:- Set Inital Condition

extension MarkdownViewController {
    
    private func setting() {
        setImagePicker()
        setTextView()
    }
    
    private func setImagePicker() {
        imagePicker.delegate = self
    }
    
    private func setTextView() {
        textView.delegate = self
        let imageMenuItem = UIMenuItem(title: "Insert Photo", action: #selector(imageMenuDidTapped(_:)))
        UIMenuController.shared.menuItems = [imageMenuItem]
    }
    
    private func bind() {
        viewModel.fetchImagePath().receive(on: DispatchQueue.main)
            .sink { [weak self] imagePath in
                self?.textView.text += imagePath
            }
            .store(in: &cancelBag)
    }
    
    @objc private func imageMenuDidTapped(_ sender: UIMenuItem) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}

//MARK: - Image Picker

extension MarkdownViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else  { return }
        let imageData = selectedImage.jpegData(compressionQuality: 0.2)
        viewModel.requestUploadImage(imageData)
        dismiss(animated: true, completion: nil)
    }
    
}

//MARK: - Editing

extension MarkdownViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        delegate?.checkTextArea()
    }
    
}
