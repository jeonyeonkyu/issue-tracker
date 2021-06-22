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
    
    private var filterIndex = FilterIndex()
    private var filter = Filter()
    
}


extension FilterUseCase {
    
    func select(index: IndexPath) {
        switch index.section {
        case 0:
            filterIndex.status = index
        case 1:
            filterIndex.writer = index
        case 2:
            filterIndex.label = index
        case 3:
            filterIndex.milestone = index
        default:
            break
        }
    }
    
    func indexPaths() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        if let status = filterIndex.status { indexPaths.append(status) }
        if let writer = filterIndex.writer { indexPaths.append(writer) }
        if let label = filterIndex.label { indexPaths.append(label) }
        if let milestone = filterIndex.milestone { indexPaths.append(milestone) }
        
        return indexPaths
    }
    
    func deselect(index: IndexPath) {
        switch index.section {
        case 0:
            filterIndex.status = nil
        case 1:
            filterIndex.writer = nil
        case 2:
            filterIndex.label = nil
        case 3:
            filterIndex.milestone = nil
        default:
            break
        }
    }
    
    func deselectAll() {
        filterIndex = FilterIndex()
    }
    
}



extension FilterUseCase {
    
    func setFilter(dataSource: [Parent]) {
        filter = Filter()
        if let statusIdx = filterIndex.status {
            let status = dataSource[statusIdx.section].children[statusIdx.row - 1].title
            filter.status = Status(rawValue: status)
        }
        if let writerIdx = filterIndex.writer {
            let writer = dataSource[writerIdx.section].children[writerIdx.row - 1].title
            filter.writer = writer
        }
        if let labelIdx = filterIndex.label {
            let label = dataSource[labelIdx.section].children[labelIdx.row - 1].title
            filter.label = label
        }
        if let milestoneIdx = filterIndex.milestone {
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
                if case logInUser.id = user.id {
                    return true
                } else {
                    return false
                }
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
