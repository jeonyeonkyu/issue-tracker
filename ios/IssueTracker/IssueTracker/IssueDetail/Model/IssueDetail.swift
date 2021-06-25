//
//  IssueDetail.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/22.
//

import Foundation

struct IssueDetail: Decodable {
    let id: Int
    let number: Int
    let title: String
    let createDateTime: String
    let author: User
    let assignees: [User]
    let labels: [Label]
    let milestone: Milestone
    let mainComment: Comment
    let comments: [Comment]?
    let closed: Bool
}
