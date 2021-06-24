//
//  MyAccountViewController.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/25.
//

import UIKit

extension MyAccountViewController: ViewControllerIdentifierable {
    
    static func create() -> LoginViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? LoginViewController else {
            return LoginViewController()
        }
        return vc
    }
    
}


class MyAccountViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
