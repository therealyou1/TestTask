//
//  Dependencies.swift
//  engenious-challenge
//
//  Created by Nikolay Voitovich on 23.05.2022.
//

import Foundation

final class Dependencies {
    lazy var requestBuilder: RequestBuilderProtocol = RequestBuilder()
    lazy var networkService: NetworkServiceProtocol =  NetworkService(baseUrl: Constants.baseAPIURL, requestBuilder: requestBuilder)
    lazy var reposService: RepositoryServiceProtocol = RepositoryService(networkService)
}
