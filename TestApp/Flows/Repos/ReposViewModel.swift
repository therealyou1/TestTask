//
//  ReposViewModel.swift
//  engenious-challenge
//
//  Created by Nikolay Voitovich on 23.05.2022.
//

import Foundation
import Combine

protocol ReposViewModelProtocol {
    var viewState: AnyPublisher<ReposModels.ViewState, Never> { get }

    func process(input: ReposModels.ViewModelInput)
}

final class ReposViewModel {

    private let repositoryService: RepositoryServiceProtocol
    private let viewStateSubj = CurrentValueSubject<ReposModels.ViewState, Never>(.idle)
    private var subscriptions: Set<AnyCancellable> = []

    init(repositoryService: RepositoryServiceProtocol) {
        self.repositoryService = repositoryService
    }
}

extension ReposViewModel: ReposViewModelProtocol {
    var viewState: AnyPublisher<ReposModels.ViewState, Never> { viewStateSubj.eraseToAnyPublisher() }

    func process(input: ReposModels.ViewModelInput) {
        input.onLoad.sink { [weak self] username in
            self?.load(username: username)
        }.store(in: &subscriptions)
    }
}

private extension ReposViewModel {
    func load(username: String) {
        repositoryService.getUserRepoCombine(username: username).sink { [weak self] completion in
            switch completion {
            case .finished:
                break
            case .failure:
                self?.viewStateSubj.send(.failure)
            }
        } receiveValue: { [weak self] repos in
            self?.viewStateSubj.send(.loaded(repos))
        }.store(in: &subscriptions)
    }
}
