//
//  LoginManager.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/23.
//

import Foundation
import Combine

class LoginManager {
    
    private let callbackUrlScheme = "issueTracker"
    
    enum LoginURL {
        static let scheme = "https"
        static let host = "github.com"
        static let path = "/login/oauth/authorize"
        static let clientID = "d" /// 민감한 정보 숨기기
        static let redirectURI = "issueTracker://login"
        static let scope = "user"
        
        static func url() -> URL? {
            var components = URLComponents()
            components.scheme = LoginURL.scheme
            components.host = LoginURL.host
            components.path = LoginURL.path
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
