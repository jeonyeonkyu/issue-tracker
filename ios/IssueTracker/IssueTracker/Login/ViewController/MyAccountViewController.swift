//
//  MyAccountViewController.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/25.
//

import UIKit

extension MyAccountViewController: ViewControllerIdentifierable {
    
    static func create(_ viewModel: MyAccountViewModel) -> MyAccountViewController {
        guard let vc = storyboard.instantiateViewController(identifier: storyboardID) as? MyAccountViewController else {
            return MyAccountViewController()
        }
        vc.viewModel = viewModel
        return vc
    }
    
}


class MyAccountViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var viewModel: MyAccountViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


extension MyAccountViewController {
    
    private func fillUI() {
        viewModel.fillUI { profileImage, name, email in
            self.profileImageView.image = profileImage
            self.nameLabel.text = name
            self.emailLabel.text = email
        }
    }
    
    @IBAction func logoutButtonTouched(_ sender: UIButton) {
        viewModel.logout()
    }
    
}
