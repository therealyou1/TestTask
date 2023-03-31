//
//  RepositoryService.swift
//  TestApp
//
//  Created by Nikolay Voitovich on 31.03.2023.
//

import Foundation
import Combine

protocol RepositoryServiceProtocol {
    func getUserRepoCombine(username: String) -> AnyPublisher<[Repo], Error>
    func getUserRepos(username: String, completion: @escaping ([Repo]) -> Void)
}

struct RepositoryService {

    let networkService: NetworkServiceProtocol

    init(_ networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
}

extension RepositoryService: RepositoryServiceProtocol {
    func getUserRepoCombine(username: String) -> AnyPublisher<[Repo], Error> {
        networkService.send(GetReposRequest(username: username)).eraseToAnyPublisher()
    }

    func getUserRepos(username: String, completion: @escaping ([Repo]) -> Void) {
        networkService.send(GetReposRequest(username: username)) { repos, error in
            guard let repos = repos else {
                return
            }
            completion(repos)

        }
    }
}
