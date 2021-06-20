//
//  FilterViewModel.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/20.
//

import Foundation
import Combine

final class FilterViewModel {
    
    @Published private var identifierFilter: [Parent]
    @Published private var error: String
    
    struct Filter {
        var status: IndexPath?
        var writer: IndexPath?
        var label: IndexPath?
        var milestone: IndexPath?
    }
    
    private var filter = Filter()
    private var filterUseCase: FetchFilterUseCase

    init(_ fetchIssueListUseCase: FetchFilterUseCase) {
        self.filterUseCase = fetchIssueListUseCase
        self.identifierFilter = MockIdentifier.parents
        self.error = ""
        loadFilters()
    }

}


extension FilterViewModel {
    
    private func loadFilters() {
        filterUseCase.excute { result in
            switch result {
            case .success(let filterList):
                self.loadFilterList(with: filterList)
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func handleError(_ error: NetworkError) {
        switch error {
        case .BadURL:
            self.error = "잘못된 URL입니다"
        case .BadRequest:
            self.error = "잘못된 요청입니다.\nURL을 다시 확인해보세요"
        case .BadResponse:
            self.error = "잘못된 response입니다."
        case .Status(let statusCode):
            self.error = "\(statusCode) 에러!"
        case .DecodingError:
            self.error = "디코딩 에러"
        case .EncodingError:
            self.error = "인코딩 에러"
        case .Unknown:
            self.error = "잘 모르겠네요😅"
        }
    }
    
    private func loadFilterList(with filterList: FilterList) {
        identifierFilter = [
            Parent(title: "상태", isStatus: true, children: Status.allCases.map { Child(title: $0.rawValue)}),
            Parent(title: "작성자", isStatus: false, children: filterList.users.map{ Child(title: $0.name)}),
            Parent(title: "레이블", isStatus: false, children: filterList.labels.map{ Child(title:  $0.name)}),
            Parent(title: "마일스톤", isStatus: false, children: filterList.mileStone.map{ Child(title:  $0.name)})
        ]
    }
    
    func fetchFilterList() -> AnyPublisher<[Parent], Never> {
        return $identifierFilter.eraseToAnyPublisher()
    }
    
    func fetchError() -> AnyPublisher<String, Never> {
        return $error.eraseToAnyPublisher()
    }
    
}

//MARK:- Selection Logic

extension FilterViewModel {
    
    func select(index: IndexPath) {
        switch index.section {
        case 0:
            filter.status = index
        case 1:
            filter.writer = index
        case 2:
            filter.label = index
        case 3:
            filter.milestone = index
        default:
            break
        }
    }
    
    func indexPaths() -> [IndexPath] {
        var indexPaths = [IndexPath]()
        if let status = filter.status { indexPaths.append(status) }
        if let writer = filter.writer { indexPaths.append(writer) }
        if let label = filter.label { indexPaths.append(label) }
        if let milestone = filter.milestone { indexPaths.append(milestone) }
        
        return indexPaths
    }
    
    func deselect(index: IndexPath) {
        switch index.section {
        case 0:
            filter.status = nil
        case 1:
            filter.writer = nil
        case 2:
            filter.label = nil
        case 3:
            filter.milestone = nil
        default:
            break
        }
    }
}

