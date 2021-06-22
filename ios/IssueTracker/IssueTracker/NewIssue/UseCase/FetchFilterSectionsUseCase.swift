//
//  FetchFilterSectionsUseCase.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/21.
//

import UIKit
import Combine

protocol FetchFilterSectionsUseCase {
    func excute(completion: @escaping (Result<FilteringSection, NetworkError>) -> Void)
}


final class DefaultFetchFilterSectionsUseCase: FetchFilterSectionsUseCase {
    
    private var networkManager: NetworkManageable
    private var cancelBag = Set<AnyCancellable>()
    
    init(_ networkManager: NetworkManageable) {
        self.networkManager = networkManager
    }
    
    func excute(completion: @escaping (Result<FilteringSection, NetworkError>) -> Void) {
        
        networkManager.get(path: "/labels", type: [FilterItem].self)
            .receive(on: DispatchQueue.main)
            .sink { error in
                switch error {
                case .failure(let error): completion(.failure(error))
                case .finished: break
                }
            } receiveValue: { items in
                let section = FilteringSection.init(name: "Label", items: items)
                completion(.success(section))
            }.store(in: &cancelBag)
        
        networkManager.get(path: "/milestones", type: [FilterItem].self)
            .receive(on: DispatchQueue.main)
            .sink { error in
                switch error {
                case .failure(let error): completion(.failure(error))
                case .finished: break
                }
            } receiveValue: { items in
                let section = FilteringSection.init(name: "Milestone", items: items)
                completion(.success(section))
            }.store(in: &cancelBag)
        
        networkManager.get(path: "/users", type: [FilterItem].self)
            .receive(on: DispatchQueue.main)
            .sink { error in
                switch error {
                case .failure(let error): completion(.failure(error))
                case .finished: break
                }
            } receiveValue: { items in
                let section = FilteringSection.init(name: "Assignee", items: items)
                completion(.success(section))
            }.store(in: &cancelBag)
    }
    
}
