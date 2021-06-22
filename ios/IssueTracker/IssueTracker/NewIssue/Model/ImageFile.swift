//
//  ImageFile.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/21.
//

import Foundation

struct ImageFile: Decodable {
    let id: Int
    let name: String
    let path: String
    
    func markdownImagePath() -> String {
        return "![\(name)](https://issue-tracker-swagger.herokuapp.com\(path))"
    }
}
