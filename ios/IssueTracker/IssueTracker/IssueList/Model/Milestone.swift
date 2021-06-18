//
//  Milestone.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/09.
//

import Foundation

struct Milestone: Decodable {
    let id: Int
    let name: String
    let description: String?
    let dueDate: String
    let openedIssueCount: Int
    let closedIssueCount: Int
    let closed: Bool
}
