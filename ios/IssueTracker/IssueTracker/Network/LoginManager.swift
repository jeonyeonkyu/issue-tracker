//
//  LoginManager.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/23.
//

import Foundation
import Combine

class LoginManager {
    
    struct JWT: Decodable {
        let jwt: String
    }
    
    @Published private var jwt: JWT!
    @Published private var error: NetworkError?
    
    private var networkManager: NetworkManageable!
    private var cancelBag = Set<AnyCancellable>()
    
    init(networkManager: NetworkManageable) {
        self.networkManager = networkManager
        self.jwt = JWT(jwt: "")
        self.error = nil
    }
    
}

extension LoginManager {
    
    func requestCode(handler: @escaping (URL, String)->()) {
        let url = LoginURL.url()!
        handler(url, LoginURL.callbackUrlScheme)
    }
    
    func requestJWT(with code: URL) {
        let code = abstractCode(with: code)
        let url = "http://15.164.68.136:80/api/login/auth?client=ios&code=\(code)"
        NetworkManager().get(path: url, type: JWT.self)
            .receive(on: DispatchQueue.main)
            .sink { error in
                switch error {
                case .failure(let error): self.error = error
                case .finished: break
                }
            } receiveValue: { jwt in
                self.jwt = jwt
            }.store(in: &cancelBag)
    }
    
    private func abstractCode(with url: URL) -> String {
        if url.absoluteString.starts(with: "issueTracker://") {
            if let code = url.absoluteString.split(separator: "=").last.map({ String($0) }) {
                return code
            }
        }
        return ""
    }
    
}

