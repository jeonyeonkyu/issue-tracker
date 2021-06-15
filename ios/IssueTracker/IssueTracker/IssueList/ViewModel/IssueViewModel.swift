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
    
    private var fetchIssueListUseCase: FetchIssueListUseCase

    init(_ fetchIssueListUseCase: FetchIssueListUseCase) {
        self.fetchIssueListUseCase = fetchIssueListUseCase
        self.issues = []
        loadIssues()
    }

}


extension IssueViewModel {
    
    private func loadIssues() {
        fetchIssueListUseCase.excute { result in
            switch result {
            case .success(let issues):
                self.issues = issues
            case .failure(let error):
                self.error = error
            }
        }
    }

    func deleteIssue(at index: Int) {
        issues.remove(at: index)
    }
    
}
