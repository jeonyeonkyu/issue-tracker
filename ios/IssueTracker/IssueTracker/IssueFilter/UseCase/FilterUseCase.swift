//
//  FilterUseCase.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/20.
//

import Foundation
import Combine

protocol FilterUseCase {
    func excute(completion: @escaping (Result<FilterList, NetworkError>) -> Void)
}


final class DefaultFilterUseCase: FilterUseCase {
    
    private var networkManager: NetworkManageable
    private var cancelBag = Set<AnyCancellable>()
    
    init(networkManager: NetworkManageable) {
        self.networkManager = networkManager
    }
    
}


extension DefaultFilterUseCase {
    
    func excute(completion: @escaping (Result<FilterList, NetworkError>) -> Void) {
        let users = networkManager.get(path: "/users", type: [User].self)
        let labels = networkManager.get(path: "/labels", type: [Label].self)
        let milestones = networkManager.get(path: "/milestones", type: [Milestone].self)
        
        users
            .zip(labels, milestones)
            .sink { error in
                switch error {
                case .failure(let error): completion(.failure(error))
                case .finished: break
                }
            } receiveValue: { users, labels, milestones in
                let filter = FilterList(users: users, labels: labels, mileStone: milestones)
                completion(.success(filter))
            }.store(in: &cancelBag)
    }
    
}


extension DefaultFilterUseCase {
    
    func filter(issues: [Issue]) {
        
    }
    
}


final class MockFilterUseCase: FilterUseCase {
    
    func excute(completion: @escaping (Result<FilterList, NetworkError>) -> Void) {
//        completion(.success())
    }
    
}

struct FilterList {
    let users: [User]
    let labels: [Label]
    let mileStone: [Milestone]
}
