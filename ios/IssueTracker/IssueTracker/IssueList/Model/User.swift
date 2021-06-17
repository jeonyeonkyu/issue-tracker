//
//  User.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/09.
//

import Foundation

struct User: Decodable {
    var id: Int
    var email: String
    var name: String
    var profileImage: String
}
