//
//  Repo.swift
//  TestApp
//
//  Created by Nikolay Voitovich on 31.03.2023.
//

import Foundation

struct Repo: Codable, Equatable {
    var name: String
    var description: String?
    var url: String

    enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case url = "url"
    }
}
