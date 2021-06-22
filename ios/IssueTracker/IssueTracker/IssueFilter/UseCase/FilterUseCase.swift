//
//  FilterUseCase.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/21.
//

import Foundation

class FilterUseCase {
    
    struct FilterIndex {
        var status: IndexPath?
        var writer: IndexPath?
        var label: IndexPath?
        var milestone: IndexPath?
    }
    
    struct Filter {
        var status: Status?
        var writer: String?
        var label: String?
        var milestone: String?
    }
    
    private var selectedIndex = FilterIndex()
    private(set) var savedIndex = [IndexPath]()
    private var filter = Filter()
    
}


extension FilterUseCase {
    
    func select(index: IndexPath) {
        switch index.section {
        case 0:
            selectedIndex.status = index
        case 1:
            selectedIndex.writer = index
        case 2:
            selectedIndex.label = index
        case 3:
            selectedIndex.milestone = index
        default:
            break
        }
    }
    
    func selectedIndexPaths() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        if let status = selectedIndex.status { indexPaths.append(status) }
        if let writer = selectedIndex.writer { indexPaths.append(writer) }
        if let label = selectedIndex.label { indexPaths.append(label) }
        if let milestone = selectedIndex.milestone { indexPaths.append(milestone) }
        
        return indexPaths
    }
    
    func deselect(index: IndexPath) {
        switch index.section {
        case 0:
            selectedIndex.status = nil
        case 1:
            selectedIndex.writer = nil
        case 2:
            selectedIndex.label = nil
        case 3:
            selectedIndex.milestone = nil
        default:
            break
        }
    }
    
    func deselectAll() {
        selectedIndex = FilterIndex()
    }
    
    func saveIndexPaths() {
        savedIndex = selectedIndexPaths()
    }
    
    func resetSelectedIndexPaths() {
        savedIndex.forEach{ self.select(index: $0) }
    }
    
}



extension FilterUseCase {
    
    func setFilter(dataSource: [Parent]) {
        filter = Filter()
        if let statusIdx = selectedIndex.status {
            let status = dataSource[statusIdx.section].children[statusIdx.row - 1].title
            filter.status = Status(rawValue: status)
        }
        if let writerIdx = selectedIndex.writer {
            let writer = dataSource[writerIdx.section].children[writerIdx.row - 1].title
            filter.writer = writer
        }
        if let labelIdx = selectedIndex.label {
            let label = dataSource[labelIdx.section].children[labelIdx.row - 1].title
            filter.label = label
        }
        if let milestoneIdx = selectedIndex.milestone {
            let milestone = dataSource[milestoneIdx.section].children[milestoneIdx.row - 1].title
            filter.milestone = milestone
        }
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
            return issues.filter{ $0.author.id == logInUser.id }
        case .assigned:
            return issues.filter { $0.assignees?.contains(where: { user in
                if case logInUser.id = user.id { return true }
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

let logInUser = User(id: 1, email: "", name: "freddie", profileImage: "")
