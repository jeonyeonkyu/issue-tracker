//
//  LoginManager.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/23.
//

import Foundation
import Combine

class LoginManager {
    
}

extension LoginManager {
    
    func requestCode(handler: @escaping (URL, String)->()) {
        let url = LoginURL.url()!
        handler(url, LoginURL.callbackUrlScheme)
    }
    
}
