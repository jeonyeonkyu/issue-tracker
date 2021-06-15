//
//  IssueViewModel.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/09.
//

import Foundation
import Combine

class IssueViewModel {
    
    @Published var issues: [Issue]
    @Published var error: Error!
    
    private var networkManager: NetworkManageable
    private var cancelBag = Set<AnyCancellable>()
    
    init(issues: [Issue] = [], networkManager: NetworkManageable = NetworkManager()) {
        self.issues = issues
        self.networkManager = networkManager
    }
    
}


extension IssueViewModel {

    func deleteIssue(at index: Int) {
        issues.remove(at: index)
    }
    
}


extension IssueViewModel  {
    
    func requestIssues() {
        networkManager.get(path: "/issues", type: Issues.self)
            .receive(on: DispatchQueue.main)
            .sink { error in
                self.error = error as? Error
            } receiveValue: { issues in
                self.issues = issues.issues
            }.store(in: &cancelBag)
    }
    
}
