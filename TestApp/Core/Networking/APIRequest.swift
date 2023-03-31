//
//  APIRequest.swift
//  engenious-challenge
//
//  Created by Nikolay Voitovich on 23.05.2022.
//

import Foundation

protocol APIRequest: Encodable {
    associatedtype Response: Decodable

    var resourceName: String { get }
    var method: HttpMethod { get }
}
