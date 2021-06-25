//
//  NewIssueFilterUseCase.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/24.
//

import Foundation

protocol FilterListFiterable: FilterUseCase {
    func resetSavedIndex()
    func filteringSection() -> [[Child?]]
}

final class NewIssueFilterUseCase: FilterListFiterable {
    
    enum FilteringList: Int, CaseIterable {
        case label
        case milestone
        case assignees
    }
    
    struct Filter {
        var writer: String?
        var label: String?
        var milestone: String?
    }
    
    private var selectedIndex: [[IndexPath?]]
    private(set) var savedIndex: [IndexPath]
    private var filterItem: [Parent]
    
    init() {
        self.selectedIndex = []
        self.savedIndex = []
        self.filterItem = []
        setSelectedIndex()
    }
    
    private func setSelectedIndex() {
        FilteringList.allCases.forEach { _ in
            selectedIndex.append([])
        }
    }
    
}


extension NewIssueFilterUseCase {
    
    func select(index: IndexPath) {
        FilteringList.allCases
            .filter { $0.rawValue == index.section }
            .forEach {
                if index.section == FilteringList.milestone.rawValue {
                    selectedIndex[$0.rawValue] = [index]
                } else {
                    selectedIndex[$0.rawValue].append(index)
                }
            }
    }
    
    func selectedIndexPaths() -> [IndexPath] {
        return selectedIndex.flatMap { $0 }.compactMap { $0 }
    }
    
    func deselect(index: IndexPath) {
        FilteringList.allCases
            .filter { $0.rawValue == index.section }
            .forEach {
                guard let deselectIndex = selectedIndex[$0.rawValue].firstIndex(of: index) else { return }
                selectedIndex[$0.rawValue].remove(at: deselectIndex) }
    }
    
    func deselectAll() {  }
    
    func resetSavedIndex() {
        savedIndex = []
    }
    
    func saveIndexPaths() {
        savedIndex = selectedIndexPaths()
    }
    
    func resetSelectedIndexPaths() {
        savedIndex.forEach{ self.select(index: $0) }
    }
    
}



extension NewIssueFilterUseCase {
    
    func setFilter(dataSource: [Parent]) {
        self.filterItem = dataSource
    }
    
    func filteringSection() -> [[Child?]] {
        
        return selectedIndex.enumerated().map { (index, section) -> [Child?] in
            let children = section.map { indexPath -> Child? in
                guard let indexPath = indexPath else { return nil }
                let parent = filterItem[index]
                return parent.children[indexPath.row - 1]
            }
            return children
        }
    }
    
}
