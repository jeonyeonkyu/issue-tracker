//
//  FilterUseCase.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/25.
//

import Foundation

protocol FilterUseCase {
    var savedIndex: [IndexPath] { get }
    func select(index: IndexPath)
    func selectedIndexPaths() -> [IndexPath]
    func deselect(index: IndexPath)
    func deselectAll()
    func saveIndexPaths()
    func resetSelectedIndexPaths()
    func setFilter(dataSource: [Parent])
}
