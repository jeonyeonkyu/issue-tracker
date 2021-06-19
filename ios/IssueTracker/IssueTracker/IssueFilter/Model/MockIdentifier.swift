//
//  MockIdentifier.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/20.
//

import Foundation

struct MockIdentifier {
    static let parents = [
        Parent(title: "상태", isStatus: true, children: Status.allCases.map { Child(title: $0.rawValue) }),
        Parent(title: "작성자", isStatus: false, children: [
            Child(title: "Dumba"),
            Child(title: "Lia"),
            Child(title: "Beemo"),
            Child(title: "Hiro"),
        ]),
        Parent(title: "레이블", isStatus: false, children: [
            Child(title: "Documentation"),
            Child(title: "bug"),
            Child(title: "iOS"),
            Child(title: "BE"),
        ]),
        Parent(title: "마일스톤", isStatus: false, children: [
            Child(title: "Filter"),
            Child(title: "NewIssue"),
            Child(title: "MockData"),
            Child(title: "OAuth"),
        ])
    ]
}
