//
//  IssueFilterableUseCase.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/21.
//

import Foundation


protocol IssueFilterableUseCase: FilterUseCase {
    func filterIssue(with issues: [Issue]) -> [Issue]
}

final class IssueListFilterUseCase: IssueFilterableUseCase {
    
    enum FilteringList: Int, CaseIterable {
        case status
        case writer
        case label
        case milestone
    }
    
    struct Filter {
        var status: Status?
        var writer: String?
        var label: String?
        var milestone: String?
    }
    
    private var selectedIndex: [IndexPath?]
    private(set) var savedIndex: [IndexPath]
    private var filter: Filter
    
    init() {
        self.selectedIndex = []
        self.savedIndex = []
        self.filter = Filter()
        
        setSelectedIndex()
    }
    
    private func setSelectedIndex() {
        FilteringList.allCases.forEach { _ in
            selectedIndex.append(nil)
        }
    }
    
}


extension IssueListFilterUseCase {
    
    func select(index: IndexPath) {
        FilteringList.allCases
            .filter { $0.rawValue == index.section }
            .forEach { selectedIndex[$0.rawValue] = index }
    }
    
    func selectedIndexPaths() -> [IndexPath] {
        return selectedIndex.compactMap{$0}
    }
    
    func deselect(index: IndexPath) {
        FilteringList.allCases
            .filter { $0.rawValue == index.section }
            .forEach { selectedIndex[$0.rawValue] = nil }
    }
    
    func deselectAll() {
        FilteringList.allCases.forEach {
            selectedIndex[$0.rawValue] = nil
        }
    }
    
    func saveIndexPaths() {
        savedIndex = selectedIndexPaths()
    }
    
    func resetSelectedIndexPaths() {
        savedIndex.forEach{ self.select(index: $0) }
    }
    
}



extension IssueListFilterUseCase {
    
    func setFilter(dataSource: [Parent]) {
        var newFilter = Filter()
        
        func selectedTitle(_ list: FilteringList) -> String? {
            guard let indexPath = selectedIndex[list.rawValue] else { return nil }
            return dataSource[indexPath.section].children[indexPath.row - 1].title
        }
        
        newFilter.status = Status(rawValue: selectedTitle(.status) ?? "")
        newFilter.writer = selectedTitle(.writer)
        newFilter.label = selectedTitle(.label)
        newFilter.milestone = selectedTitle(.milestone)
        
        self.filter = newFilter
    }
    
    func filterIssue(with issues: [Issue]) -> [Issue] {
        var filteredIssues = filterStatus(with: issues)
        if let writer = filter.writer {
            filteredIssues = filteredIssues.filter{ $0.author.name == writer }
        }
        if let label = filter.label {
            filteredIssues = filteredIssues.filter{ $0.labels?.contains(where: { alabel in
                if case label = alabel.name { return true }
                else { return false }
            }) ?? true }
        }
        if let milestone = filter.milestone {
            filteredIssues = filteredIssues.filter{ $0.milestone?.name == milestone }
        }
        return filteredIssues
    }
    
    private func filterStatus(with issues: [Issue]) -> [Issue] {
        switch filter.status {
        case .written:
            return issues.filter{ $0.author.id == UserMock.freddie.id }
        case .assigned:
            return issues.filter { $0.assignees?.contains(where: { user in
                if case UserMock.freddie.id = user.id { return true }
                else {  return false }
            }) ?? true }
        case .commented:
            return issues.filter{ $0.hasSameAuthorComments }
        case .opened:
            return issues.filter{ !$0.closed }
        case .closed:
            return issues.filter{ $0.closed }
        default:
            return issues
        }
    }
    
}
