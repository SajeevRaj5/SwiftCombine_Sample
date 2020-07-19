//
//  ServiceManager.swift
//  LiveStyledTest
//
//  Created by sajeev Raj on 1/17/20.
//  Copyright © 2020 LiveStyled. All rights reserved.
//

import Foundation
import Combine

class Configuration {
    
    static var BaseUrl: String {
        return "http://dummy.restapiexample.com/api/v1"
    }
}

struct Response<T> {
    let value: T
    let response: URLResponse
}

enum RequestError: Error {
    case sessionError(error: Error)
}

class ServiceManager {
    
    static let shared = ServiceManager()
        
    var dataTask: URLSessionDataTask?
    var cancelable: AnyCancellable? = nil

    private init() {}
    
    func request<T: Codable>(request: URLRequest, completion: (AnyPublisher<T, RequestError>) -> ()) {
        completion( run(request: request)
            .map (\.value)
            .eraseToAnyPublisher()
        )
    }
    
    func run<T: Codable>(request: URLRequest) -> AnyPublisher<Response<T>, RequestError> {
        let decoder = JSONDecoder()
       let result = URLSession.shared
            .dataTaskPublisher(for: request)
            .tryMap { (result) -> Response<T> in
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
        }
       .mapError({ (error) -> RequestError in
        return RequestError.sessionError(error: error)
       })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
        
        return result
    }
}

extension ServiceManager {
    struct API {
        static var baseUrl: URL? {
            return URL(string: Configuration.BaseUrl)
        }
    }
}

enum HTTPMethod: String {
    case get
    case post
    case update
    case delete
}

extension Subscribers {
    public enum Completion<Failure> where Failure : Error {
        case finished
        case failure(Failure)
    }
}
