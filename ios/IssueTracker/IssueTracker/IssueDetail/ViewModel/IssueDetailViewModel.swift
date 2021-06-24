//
//  IssueDetailViewModel.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/22.
//

import Foundation
import Combine

final class IssueDetailViewModel: DateManagable {
    
    @Published private(set) var issue: IssueDetail
    
    var stateDescription: String {
        let intervalTime = intervalTime(historyTime: issue.createDateTime)
        return "\(intervalTime), \(issue.author.name)님이 작성했습니다."
    }
    
    init(issue: IssueDetail) {
        self.issue = issue
    }
    
    func fetchIssue() -> AnyPublisher<IssueDetail, Never> {
        return $issue.eraseToAnyPublisher()
    }
    
}
