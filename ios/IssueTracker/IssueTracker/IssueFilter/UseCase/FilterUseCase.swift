//
//  FilterUseCase.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/21.
//

import Foundation

class FilterUseCase {
    
    struct Filter {
        var status: IndexPath?
        var writer: IndexPath?
        var label: IndexPath?
        var milestone: IndexPath?
    }
    
    private var filter = Filter()
    
}


extension FilterUseCase {
    
    func select(index: IndexPath) {
        switch index.section {
        case 0:
            filter.status = index
        case 1:
            filter.writer = index
        case 2:
            filter.label = index
        case 3:
            filter.milestone = index
        default:
            break
        }
    }
    
    func indexPaths() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        if let status = filter.status { indexPaths.append(status) }
        if let writer = filter.writer { indexPaths.append(writer) }
        if let label = filter.label { indexPaths.append(label) }
        if let milestone = filter.milestone { indexPaths.append(milestone) }
        
        return indexPaths
    }
    
    func deselect(index: IndexPath) {
        switch index.section {
        case 0:
            filter.status = nil
        case 1:
            filter.writer = nil
        case 2:
            filter.label = nil
        case 3:
            filter.milestone = nil
        default:
            break
        }
    }
    
}
