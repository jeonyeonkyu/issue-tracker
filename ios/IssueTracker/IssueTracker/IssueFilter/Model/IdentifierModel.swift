//
//  IdentifierModel.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/20.
//

import Foundation

enum DataItem: Hashable {
    case parent(Parent)
    case child(Child)
}

struct Parent: Hashable {
    let title: String
    let isStatus: Bool
    let children: [Child]
}

struct Child: Hashable {
    let title: String
    let id = UUID()
}

enum Status: String, CaseIterable {
    case written = "내가 작성한 이슈"
    case assigned = "나에게 할당된 이슈"
    case commented = "내가 댓글을 남긴 이슈"
    case opened = "열린 이슈"
    case closed = "닫힌 이슈"
}
