//
//  ReposViewController.swift
//  TestApp
//
//  Created by Nikolay Voitovich on 31.03.2023.
//

import UIKit
import Combine

final class ReposViewController: UIViewController {

    private let username: String = "Apple"
    private var repoList: [Repo] = []

    private let viewModel: ReposViewModelProtocol
    private var subscriptions = Set<AnyCancellable>()

    private let onLoad = PassthroughSubject<String, Never>()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(RepoTableViewCell.self, forCellReuseIdentifier: String(describing: RepoTableViewCell.self))
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        return tv
    }()

    init(viewModel: ReposViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind(to: viewModel)
        onLoad.send(username)
    }
}

private extension ReposViewController {
    func setupUI() {
        title = "Apple's repos"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .white
        tableView.dataSource = self
        view.addSubview(tableView)
        NSLayoutConstraint.activate(tableViewConstraints)
    }

    func bind(to viewModel: ReposViewModelProtocol) {
        let input = ReposModels.ViewModelInput(onLoad: onLoad.eraseToAnyPublisher())
        viewModel.process(input: input)

        viewModel.viewState
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.render(state)
            }.store(in: &subscriptions)
    }

    func render(_ state: ReposModels.ViewState) {
        switch state {
        case .idle:
            break
        case let .loaded(repos):
            self.repoList = repos
            self.tableView.reloadData()
        case .failure:
            break
        }
    }
}

extension ReposViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repoList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RepoTableViewCell.self)) as? RepoTableViewCell else { return UITableViewCell() }
        let repo = repoList[indexPath.row]
        cell.setup(with: repo)
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repositories"
    }
}

// MARK: Constraints
private extension ReposViewController {
    var tableViewConstraints: [NSLayoutConstraint] {
        [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
    }
}
