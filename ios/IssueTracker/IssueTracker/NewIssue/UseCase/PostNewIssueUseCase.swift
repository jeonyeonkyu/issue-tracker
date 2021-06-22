//
//  PostNewIssueUseCase.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/18.
//

import Foundation
import Combine

protocol PostNewIssueUseCase {
    
}

final class DefaultPostNewIssueUseCase: PostNewIssueUseCase {
    
    private var networkManager: NetworkManageable
    private var cancelBag = Set<AnyCancellable>()
    
    init(_ networkManager: NetworkManageable) {
        self.networkManager = networkManager
    }
    
    func execute(title: String, mainComments:String, authorId: Int, assigneeIds: [Int]?, labelIds: [Int]?, milestoneId: Int?, completion: @escaping (Result<DetailIssue, NetworkError>) -> Void ) {
        let newIssue = NewIssue.init(title: title, mainCommentContents: mainComments, authorId: authorId, assigneeIds: assigneeIds, labelIds: labelIds, milestoneId: milestoneId)
        networkManager.post(path: "/issues", data: newIssue, result: DetailIssue.self)
            .receive(on: DispatchQueue.main)
            .sink { error in
                switch error {
                case .failure(let error): completion(.failure(error))
                case .finished: break
                }
            } receiveValue: { detailIssue in
                completion(.success(detailIssue))
            }
            .store(in: &cancelBag)

    }
}
