//
//  LoginViewController.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/23.
//

import UIKit
import AuthenticationServices

extension LoginViewController: ViewControllerIdentifierable {
    
    static func create(_ loginManager: LoginManager) -> LoginViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LoginViewController else {
            return LoginViewController()
        }
        vc.loginManager = loginManager
        return vc
    }
    
}


class LoginViewController: UIViewController {
    
    private var webAuthSession: ASWebAuthenticationSession?
    private var loginManager: LoginManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebAuthSession()
    }
    
}


extension LoginViewController: ASWebAuthenticationPresentationContextProviding {
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window ?? ASPresentationAnchor()
    }
    
    private func configureWebAuthSession() {
        loginManager.requestCode(handler: { url, callBackUrlScheme in
            self.webAuthSession = ASWebAuthenticationSession.init(url: url, callbackURLScheme: callBackUrlScheme, completionHandler: { (callBack:URL?, error:Error?) in
                guard error == nil, let successURL = callBack else {
                    print("error") /// error message 사용자에게 띄우기
                    return
                }
                print("success", successURL)
            })
        })
        webAuthSession?.presentationContextProvider = self
    }

    @IBAction func githubLoginButtonTouched(_ sender: UIButton) {
        webAuthSession?.start()
    }
    
}
