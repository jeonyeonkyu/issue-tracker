//
//  Issue.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/09.
//

import Foundation

struct Issue: Decodable {
    let id: Int
    let number: Int
    let title: String
    let description: String
    let hasSameAuthorComments: Bool
    let createDateTime: String
    let closed: Bool
    let author: User
    let assignees: [User]?
    let labels: [Label]?
    let milestone: Milestone?
}
