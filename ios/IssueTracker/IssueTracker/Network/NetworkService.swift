//
//  NetworkService.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/14.
//

import Foundation
import Combine

protocol NetworkManageable {
    func get<T: Decodable>(path: String, type: T.Type) -> AnyPublisher<T, Error>
    func post<T: Encodable, R: Decodable>(path: String, data: T, result: R.Type) -> AnyPublisher<R, Error>
}


class NetworkManager {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
      self.session = session
    }
    
}


extension NetworkManager: NetworkManageable {
    
    func get<T: Decodable>(path: String, type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = EndPoint.url(path: path) else {
            let error = NetworkError.BadURL
            return Fail(error: error).eraseToAnyPublisher()
        }
        return get(url: url, type: type)
    }
    
    func post<T: Encodable, R: Decodable>(path: String, data: T, result: R.Type) -> AnyPublisher<R, Error> {
        guard let url = EndPoint.url(path: path) else {
            let error = NetworkError.BadURL
            return Fail(error: error).eraseToAnyPublisher()
        }
        return post(url: url, data: data, result: result)
    }
    
}


extension NetworkManager {
    
    private func get<T: Decodable>(url: URL, type: T.Type) -> AnyPublisher<T, Error> {
        
        return self.session.dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else { throw NetworkError.Unknown}
                let statusCode = httpResponse.statusCode
                if statusCode != 200 { throw NetworkError.Status(statusCode) }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError({ (error) -> Error in
                return NetworkError.DecodingError(error)
            })
            .eraseToAnyPublisher()
    }
    
    private func post<T: Encodable, R: Decodable>(url: URL, data: T, result: R.Type) -> AnyPublisher<R, Error> {

        return Just(data)
            .encode(encoder: JSONEncoder())
            .mapError { error -> Error in
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
                return self.session.dataTaskPublisher(for: request)
                    .tryMap { element -> R in
                        guard let httpResponse = element.response as? HTTPURLResponse,
                              httpResponse.statusCode == 200 else {
                            throw NetworkError.BadURL
                        }
                        let result = try JSONDecoder().decode(R.self, from: element.data)
                        return result
                    }
            }
            .eraseToAnyPublisher()
    }
    
}

