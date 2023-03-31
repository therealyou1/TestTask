//
//  RepoTableViewCell.swift
//  TestApp
//
//  Created by Nikolay Voitovich on 31.03.2023.
//

import UIKit

final class RepoTableViewCell: UITableViewCell {

    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.838, green: 0.933, blue: 1, alpha: 1)
        return view
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0, green: 0.417, blue: 0.716, alpha: 1)
        label.font = UIFont(name: "SFProText-Bold", size: 18)
        return label
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(red: 0, green: 0.283, blue: 0.487, alpha: 1)
        label.font = UIFont(name: "SFProText-Medium", size: 14)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with repo: Repo) {
        titleLabel.text = repo.name
        descriptionLabel.text = repo.description
        descriptionLabel.isHidden = repo.description == nil
    }
}

private extension RepoTableViewCell {
    func setupUI() {
        selectionStyle = .none
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        NSLayoutConstraint.activate(containerViewConstraints + stackViewContraints)
    }
}

// MARK: Constraints
private extension RepoTableViewCell {
    var containerViewConstraints: [NSLayoutConstraint] {
        [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Defaults.Container.vertical),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Defaults.Container.horizontal),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Defaults.Container.horizontal),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Defaults.Container.vertical)
        ]
    }

    var stackViewContraints: [NSLayoutConstraint] {
        [
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Defaults.Stack.insets),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Defaults.Stack.insets),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Defaults.Stack.insets),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -Defaults.Stack.insets)
        ]
    }
}

// MARK: Defaults
private extension RepoTableViewCell {
    enum Defaults {
        enum Container {
            static let vertical: CGFloat = 8
            static let horizontal: CGFloat = 20.5
        }
        enum Stack {
            static let insets: CGFloat = 16
        }
    }
}
