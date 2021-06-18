//
//  User.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/09.
//

import Foundation

struct User: Decodable {
    let id: Int
    let email: String
    let name: String
    let profileImage: String
}
