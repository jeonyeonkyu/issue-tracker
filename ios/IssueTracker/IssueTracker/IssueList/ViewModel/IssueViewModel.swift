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
    
    init(issues: [Issue] = IssueListMock.data, networkManager: NetworkManageable = NetworkManager()) {
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
    
    func requestPirce() {
        networkManager.get(path: "/issues", type: [Issue].self)
            .receive(on: DispatchQueue.main)
            .sink { error in
                self.error = error as? Error
            } receiveValue: { issues in
                self.issues = issues
            }.store(in: &cancelBag)
    }
    
}
