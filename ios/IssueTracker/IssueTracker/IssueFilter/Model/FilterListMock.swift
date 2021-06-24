//
//  MockIdentifier.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/20.
//

import Foundation

struct FilterListMock {
    static let data = FilterList(
        users: [UserMock.dumba, UserMock.lia, UserMock.beemo, UserMock.freddie, UserMock.hiro],
        labels: [LabelMock.iOSLabel, LabelMock.BELabel, LabelMock.FELabel],
        mileStone: [MilestoneMock.iOSFirstData, MilestoneMock.feFirstData]
    )
}
