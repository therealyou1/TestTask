//
//  NetworkService.swift
//  engenious-challenge
//
//  Created by Nikolay Voitovich on 23.05.2022.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func send<T: APIRequest>(_ apiRequest: T) -> AnyPublisher<T.Response, Error>
    func send<T: APIRequest>(_ apiRequest: T, completion: @escaping (T.Response?, Error?) -> Void)
}

final class NetworkService {

    private let baseURL: URL
    private let session = URLSession.shared
    private let builder: RequestBuilderProtocol

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    public init(baseUrl: URL, requestBuilder: RequestBuilderProtocol) {
        self.baseURL = baseUrl
        self.builder = requestBuilder
    }
}

extension NetworkService: NetworkServiceProtocol {
    func send<T>(_ apiRequest: T) -> AnyPublisher<T.Response, Error> where T : APIRequest {
        let request: URLRequest
        do {
            request = try builder.makeRequest(apiRequest, baseURL: baseURL)
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.Response.self, decoder: decoder)
            .eraseToAnyPublisher()
    }

    func send<T>(_ apiRequest: T, completion: @escaping (T.Response?, Error?) -> Void) where T : APIRequest {
        let request: URLRequest
        do {
            request = try builder.makeRequest(apiRequest, baseURL: baseURL)
        } catch {
            completion(nil, error)
            return
        }
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NetworkingError.emptyData)
                return
            }
            do {
                let response = try self.decoder.decode(T.Response.self, from: data)
                completion(response, nil)
            } catch {
                completion(nil, error)
            }
        })
        task.resume()
    }
}
