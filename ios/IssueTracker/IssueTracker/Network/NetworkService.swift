//
//  NetworkService.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/14.
//

import Foundation
import Combine

protocol NetworkManageable {
    func get<T: Decodable>(path: String, _ code: String?, type: T.Type) -> AnyPublisher<T, NetworkError>
    func post<T: Encodable, R: Decodable>(path: String, data: T, result: R.Type) -> AnyPublisher<R, NetworkError>
}


class NetworkManager {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
      self.session = session
    }
    
}


extension NetworkManager: NetworkManageable {
    
    func get<T: Decodable>(path: String, _ code: String?, type: T.Type) -> AnyPublisher<T, NetworkError> {
        guard let url = EndPoint.url(path: path, nil) else {
            return Fail(error: NetworkError.BadURL).eraseToAnyPublisher()
        }
        let urlRequest = URLRequest(url: url)
        return request(with: urlRequest, type: type)
    }
    
    func post<T: Encodable, R: Decodable>(path: String, data: T, result: R.Type) -> AnyPublisher<R, NetworkError> {
        guard let url = EndPoint.url(path: path, nil) else {
            return Fail(error: NetworkError.BadURL).eraseToAnyPublisher()
        }
        return request(url: url, data: data, result: result)
    }
    
}


extension NetworkManager {
    
    private func request<T: Decodable>(with request: URLRequest, type: T.Type) -> AnyPublisher<T, NetworkError> {
        
        return self.session.dataTaskPublisher(for: request)
            .mapError { _ in
                NetworkError.BadRequest
            }
            .flatMap { (data, response) -> AnyPublisher<T, NetworkError> in
                guard let httpResponse = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError.BadResponse).eraseToAnyPublisher()
                }
                guard 200..<300 ~= httpResponse.statusCode else {
                    return Fail(error:NetworkError.Status(httpResponse.statusCode)).eraseToAnyPublisher()
                }
                return Just(data)
                    .decode(type: T.self, decoder: JSONDecoder())
                    .mapError { error in
                        NetworkError.DecodingError(error)
                    }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
        
    private func request<T: Encodable, R: Decodable>(url: URL, data: T, result: R.Type) -> AnyPublisher<R, NetworkError> {
        
        return Just(data)
            .encode(encoder: JSONEncoder())
            .mapError { error -> NetworkError in
                return NetworkError.EncodingError(error)
            }
            .map { data -> URLRequest in
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethodType.post
                request.httpBody = data
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(String(data.count), forHTTPHeaderField: "Content-Length")
                
                return request
            }
            .flatMap { request in
                return self.request(with: request, type: R.self)
            }.eraseToAnyPublisher()
    }
    
}
