//
//  SubjectsListViewController.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-11.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import UIKit
import Moya
import RxCocoa
import RxSwift

class SubjectsListViewController: UIViewController {

	let titleLabel = UILabel()
	private let disposeBag = DisposeBag()
	fileprivate let tableView = UITableView()

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .clear
		titleLabel.text = "Subjects"
		titleLabel.font = UIFont.systemFont(ofSize: 40, weight: 10)
		titleLabel.textColor = .white

		tableView.backgroundColor = .white
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.cellIdentifier)


		layoutViews()
		setupRx()
	}

	private func layoutViews() {
		view.addSubview(titleLabel)
		view.addSubview(tableView)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
			])
	}

	private func setupRx() {
		let provider = RxMoyaProvider<PhotoIdeasAPI>()
		let viewModel = SubjectsViewModel(provider: provider)

		viewModel.activeSubjects.bind(to: tableView.rx.items(
			cellIdentifier: UITableViewCell.cellIdentifier,
			cellType: UITableViewCell.self)
		) { (row, element, cell) in
			cell.textLabel?.text = element.description
			}
			.addDisposableTo(disposeBag)

		
	}
}
