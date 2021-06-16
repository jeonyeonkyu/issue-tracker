//
//  NetworkService.swift
//  IssueTracker
//
//  Created by Lia on 2021/06/14.
//

import Foundation
import Combine

protocol NetworkManageable {
    func get<T: Decodable>(path: String, type: T.Type) -> AnyPublisher<T, NetworkError>
    func post<T: Encodable, R: Decodable>(path: String, data: T, result: R.Type) -> AnyPublisher<R, NetworkError>
}


class NetworkManager {
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
      self.session = session
    }
    
}


extension NetworkManager: NetworkManageable {
    
    func get<T: Decodable>(path: String, type: T.Type) -> AnyPublisher<T, NetworkError> {
        let url = EndPoint.url(path: path)!
        
        return self.session.dataTaskPublisher(for: url)
            .mapError{ error -> NetworkError in
                return NetworkError.BadURL
            }
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse else { throw NetworkError.Unknown }
                let statusCode = httpResponse.statusCode
                if statusCode != 200 { throw NetworkError.Status(statusCode) }
                return element.data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError{ error -> NetworkError in
                return NetworkError.DecodingError(error)
            }
            .eraseToAnyPublisher()
    }
    
    func post<T: Encodable, R: Decodable>(path: String, data: T, result: R.Type) -> AnyPublisher<R, NetworkError> {
        let url = EndPoint.url(path: path)!
        
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
                return self.session.dataTaskPublisher(for: request)
                    .mapError{ error -> NetworkError in
                        return NetworkError.BadURL
                    }
                    .tryMap { element in
                        guard let httpResponse = element.response as? HTTPURLResponse else { throw NetworkError.Unknown }
                        let statusCode = httpResponse.statusCode
                        if statusCode != 200 { throw NetworkError.Status(statusCode) }
                        return element.data
                    }
                    .decode(type: R.self, decoder: JSONDecoder())
                    .mapError({ (error) -> NetworkError in
                        return NetworkError.DecodingError(error)
                    })
            }
            .eraseToAnyPublisher()
    }
    
}
