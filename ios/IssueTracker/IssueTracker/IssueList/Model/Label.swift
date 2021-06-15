//
//  Label.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/09.
//

import Foundation

struct Label: Codable {
    var id: Int
    var name: String
    var description: String?
    var color: String
}

struct Labels: Codable {
    var labels: [Label]
}
