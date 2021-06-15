//
//  IssueViewModel.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/09.
//

import Foundation
import Combine

class IssueViewModel {
    
<<<<<<< HEAD
    @Published var issues: [Issue]
    @Published var error: Error!
    
    private var networkManager: NetworkManageable
    private var cancelBag = Set<AnyCancellable>()
    
    init(issues: [Issue] = [], networkManager: NetworkManageable = NetworkManager()) {
        self.issues = issues
        self.networkManager = networkManager
=======
    private(set) var issues: [Issue]
    private(set) var error: Error?
    
    private var fetchIssueListUseCase: FetchIssueListUseCase

    init(_ fetchIssueListUseCase: FetchIssueListUseCase) {
        self.fetchIssueListUseCase = fetchIssueListUseCase
        self.issues = []
        load()
>>>>>>> iOS/main
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
