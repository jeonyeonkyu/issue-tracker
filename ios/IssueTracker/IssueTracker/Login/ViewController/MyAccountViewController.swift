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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


extension MyAccountViewController {
    
    @IBAction func logoutButtonTouched(_ sender: UIButton) {
        
    }
    
}
