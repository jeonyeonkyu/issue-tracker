//
//  LoginManager.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/23.
//

import Foundation

class LoginManager {
    
    private let callbackUrlScheme = "issue"
    
    enum LoginURL {
        static let scheme = "https"
        static let host = "github.com/login/oauth/authorize"
        static let clientID = "123456789"
        static let redirectURI = "issue://login"
        static let scope = "user"
        
        static func url() -> URL? {
            var components = URLComponents()
            components.scheme = LoginURL.scheme
            components.host = LoginURL.host
            components.queryItems = [
                URLQueryItem(name: "client_id", value: clientID),
                URLQueryItem(name: "redirect_uri", value: redirectURI),
                URLQueryItem(name: "scope", value: scope)
            ]
            return components.url
        }
    }
}


extension LoginManager {
    
    func requestCode(handler: @escaping (URL, String)->()) {
        let url = LoginURL.url()!
        handler(url, callbackUrlScheme)
    }
    
}
