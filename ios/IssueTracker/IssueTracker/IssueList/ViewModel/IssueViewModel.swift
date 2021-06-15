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
    private var fetchIssueListUseCase: FetchIssueListUseCase
    private var cancelBag = Set<AnyCancellable>()  

    init(_ fetchIssueListUseCase: FetchIssueListUseCase, networkManager: NetworkManageable = NetworkManager()) {
        self.fetchIssueListUseCase = fetchIssueListUseCase
        self.networkManager = networkManager
        self.issues = []
        load()
    }
    
    private func load() {
        fetchIssueListUseCase.excute { result in
            switch result {
            case .success(let issues):
                self.issues = issues
            case .failure(let error):
                self.error = error
            }
        }
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
