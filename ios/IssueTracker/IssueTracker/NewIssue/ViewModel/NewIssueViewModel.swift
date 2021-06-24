//
//  NewIssueViewModel.swift
//  IssueTracker
//
//  Created by 지북 on 2021/06/18.
//

import Foundation
import Combine

struct FilteringSection {
    var name: String
    var items: [FilterItem]
    var collapsed: Bool
    
    init(name: String, items: [FilterItem], collapsed: Bool = true) {
        self.name = name
        self.items = items
        self.collapsed = collapsed
      }
}


final class NewIssueViewModel {
    
    @Published private(set) var error: String
    @Published private(set) var filteringSections: [FilteringSection] = []
    @Published private(set) var imagePath: String
    
    private var fetchFilterSectionsUseCase: FetchFilterSectionsUseCase
    private var postNewIssueUseCase: PostNewIssueUseCase
    private var uploadImageUseCase: UploadImageUseCase
    
    var bodyText: String?
    
    init(_ fetchFilterSectionsUseCase: FetchFilterSectionsUseCase, _ postNewIssueUseCase: PostNewIssueUseCase, _ postImageFileUseCase: UploadImageUseCase) {
        self.fetchFilterSectionsUseCase = fetchFilterSectionsUseCase
        self.postNewIssueUseCase = postNewIssueUseCase
        self.uploadImageUseCase = postImageFileUseCase
        self.error = ""
        self.imagePath = ""
        load()
    }
    
    private func load() {
        fetchFilterSectionsUseCase.excute { result in
            switch result {
            case .success(let filteringSection):
                self.filteringSections.append(filteringSection)
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
    
    func fetchFilteringSections() -> AnyPublisher<[FilteringSection], Never> {
        return $filteringSections.eraseToAnyPublisher()
    }
    
    func fetchError() -> AnyPublisher<String, Never> {
        return $error.eraseToAnyPublisher()
    }
    
    func fetchImagePath() -> AnyPublisher<String, Never> {
        return $imagePath.eraseToAnyPublisher()
    }
    
    func changeCollapsed(with section: Int) {
        let collapsed = filteringSections[section].collapsed
        filteringSections[section].collapsed = !collapsed
    }
    
    func requestUploadImage(_ data: Data?) {
        uploadImageUseCase.excute(data: data) { result in
            switch result {
            case .success(let imageFile):
                self.imagePath = imageFile.markdownImagePath()
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    func saveNewIssue(_ title: String, _ comments: String, completion: @escaping (IssueDetail) -> Void ) {
        postNewIssueUseCase.execute(title: title,
                                    mainComments: comments,
                                    authorId: 0,
                                    assigneeIds: [0],
                                    labelIds: [0],
                                    milestoneId: 0)
        { result in
            switch result {
            case .success(let issueDetail):
                completion(issueDetail)
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
}
