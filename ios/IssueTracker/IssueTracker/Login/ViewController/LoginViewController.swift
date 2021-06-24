//
//  LoginViewController.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/23.
//

import UIKit
import Combine
import AuthenticationServices

extension LoginViewController: ViewControllerIdentifierable {
    
    static func create(_ viewModel: LoginViewModel) -> LoginViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LoginViewController else {
            return LoginViewController()
        }
        vc.viewModel = viewModel
        return vc
    }
    
}


class LoginViewController: UIViewController {
    
    private var webAuthSession: ASWebAuthenticationSession?
    private var viewModel: LoginViewModel!
    private var cancelBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebAuthSession()
        bind()
    }
    
}


extension LoginViewController: ASWebAuthenticationPresentationContextProviding, Alertable {
    
    private func bind() {
        viewModel.fetchError()
            .dropFirst(3)
            .receive(on: DispatchQueue.main)
            .sink { error in
                self.showAlert(message: error)
            }.store(in: &cancelBag)
    }
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    private func configureWebAuthSession() {
        viewModel.initAuthSession { authenticationSession in
            self.webAuthSession = authenticationSession
        }
        webAuthSession?.presentationContextProvider = self
    }

    @IBAction func githubLoginButtonTouched(_ sender: UIButton) {
        webAuthSession?.start()
    }
    
}

protocol Alertable { }

extension Alertable where Self: UIViewController {
    func showAlert(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: completion)
    }
    
    func showAlertWithDimiss(title: String = "", message: String, preferredStyle: UIAlertController.Style = .alert, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: completion)
    }
}
