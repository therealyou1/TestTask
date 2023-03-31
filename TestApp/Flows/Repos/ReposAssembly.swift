//
//  ReposAssembly.swift
//  engenious-challenge
//
//  Created by Nikolay Voitovich on 23.05.2022.
//

import UIKit

enum ReposAssembly {
    static func createModule(repositoryService: RepositoryServiceProtocol) -> UIViewController {
        let viewModel = ReposViewModel(repositoryService: repositoryService)
        return ReposViewController(viewModel: viewModel)
    }
}
