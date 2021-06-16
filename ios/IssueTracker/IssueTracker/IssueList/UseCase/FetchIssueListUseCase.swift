//
//  FetchIssueListUseCase.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/15.
//

import UIKit
import Combine

protocol FetchIssueListUseCase {
    func excute(completion: @escaping (Result<[Issue], NetworkError>) -> Void)
}


class DefaultFetchIssueListUseCase: FetchIssueListUseCase {
    
    private var networkManager: NetworkManageable
    private var cancelBag = Set<AnyCancellable>()
    
    init(networkManager: NetworkManageable) {
        self.networkManager = networkManager
    }
    
    func excute(completion: @escaping (Result<[Issue], NetworkError>) -> Void) {
        networkManager.get(path: "/issues", type: [Issue].self)
            .receive(on: DispatchQueue.main)
            .sink { error in
                switch error {
                case .failure(let error): completion(.failure(error))
                case .finished: print("🔥")
                }
            } receiveValue: { issues in
                completion(.success(issues))
            }.store(in: &cancelBag)
    }
    
}


class MockFetchIssueListUseCase: FetchIssueListUseCase {
    
    func excute(completion: @escaping (Result<[Issue], NetworkError>) -> Void) {
//        completion(.success(IssueListMock.data))
        //MARK: mock data 수정 필요
    }
    
}
