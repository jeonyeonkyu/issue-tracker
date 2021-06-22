//
//  LoginViewController.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/23.
//

import UIKit

class LoginViewController: UIViewController , ViewControllerIdentifierable {
    
    static func create() -> LoginViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LoginViewController else {
            return LoginViewController()
        }
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        
}


extension LoginViewController {

    @IBAction func githubLoginButtonTouched(_ sender: UIButton) {
        
    }
    
}
