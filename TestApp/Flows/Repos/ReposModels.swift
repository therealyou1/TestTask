//
//  ReposModels.swift
//  engenious-challenge
//
//  Created by Nikolay Voitovich on 23.05.2022.
//

import Foundation
import Combine

enum ReposModels {
    
    enum ViewState: Equatable {
        case idle
        case failure
        case loaded([Repo])
    }

    struct ViewModelInput {
        let onLoad: AnyPublisher<String, Never>
    }
}
