//
//  NewIssue.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/22.
//

import Foundation

struct NewIssue: Encodable {
    let title: String
    let mainCommentContents: String
    let authorId: Int
    let assigneeIds: [Int]?
    let labelIds: [Int]?
    let milestoneId: Int?
}
