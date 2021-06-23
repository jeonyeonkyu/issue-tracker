//
//  LoginURL.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/23.
//

import Foundation

enum LoginURL {
    static let callbackUrlScheme = "issueTracker"
    static let scheme = "https"
    static let host = "github.com"
    static let path = "/login/oauth/authorize"
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
