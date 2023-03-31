//
//  GetReposRequest.swift
//  engenious-challenge
//
//  Created by Nikolay Voitovich on 23.05.2022.
//

import Foundation

struct GetReposRequest: APIRequest {
    typealias Response = [Repo]

    var method: HttpMethod { .get }
    var resourceName: String {
        "/users/\(username)/repos"
    }

    private let username: String

    init(username: String) {
        self.username = username
    }
}
