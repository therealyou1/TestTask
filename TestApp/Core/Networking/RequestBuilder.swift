//
//  RequestBuilder.swift
//  engenious-challenge
//
//  Created by Nikolay Voitovich on 23.05.2022.
//

import Foundation

protocol RequestBuilderProtocol {
    func makeRequest<T: APIRequest>(_ apiRequest: T, baseURL: URL) throws -> URLRequest
}

final class RequestBuilder: RequestBuilderProtocol {

    func makeRequest<T>(_ apiRequest: T, baseURL: URL) throws -> URLRequest where T : APIRequest {
        guard let resourceURL = URL(string: apiRequest.resourceName, relativeTo: baseURL) else {
            throw NetworkingError.invalidResource
        }
        var request = URLRequest(url: resourceURL)
        request.httpMethod = apiRequest.method.rawValue
        return request
    }
}
