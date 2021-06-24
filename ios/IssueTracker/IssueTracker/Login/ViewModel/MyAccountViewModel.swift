//
//  MyAccountViewModel.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/25.
//

import UIKit

class MyAccountViewModel {
    
    func fillUI(completion: @escaping (UIImage, String, String) -> ()) {
        guard let user = KeychainManager.loadUser() else { return }
        
        let image = convert(imageUrlString: user.profileImage)
        let name = user.name
        let email = user.email
        
        completion(image, name, email)
    }
    
    private func convert(imageUrlString: String) -> UIImage {
        guard let url = URL(string: imageUrlString) else { return UIImage() }
        let data = try? Data(contentsOf: url)
        return UIImage(data: data!) ?? UIImage()
    }
    
    func logout() {
        KeychainManager.delete()
    }
    
}
