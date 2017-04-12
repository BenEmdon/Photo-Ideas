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
	let provider = RxMoyaProvider<PhotoIdeasAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])
	let viewModel: SubjectsViewModel

	init() {
		viewModel = SubjectsViewModel(provider: provider, modelSelected: tableView.rx.modelSelected(Subject.self))
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

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

		viewModel.activeSubjects
			.asObservable()
			.bind(to: tableView.rx.items(
			cellIdentifier: UITableViewCell.cellIdentifier,
			cellType: UITableViewCell.self)
		) { (row, element, cell) in
			cell.textLabel?.text = element.description
			cell.backgroundColor = element.archived ? .green : .white
			}
			.addDisposableTo(disposeBag)
	}
}
