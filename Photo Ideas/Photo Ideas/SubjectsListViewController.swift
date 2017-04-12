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

	private let titleLabel = UILabel()
	private let subtitleLabel = UILabel()
	private let disposeBag = DisposeBag()
	fileprivate let tableView = UITableView()
	let provider = RxMoyaProvider<PhotoIdeasAPI>()
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
		titleLabel.text = "Photo Ideas"
		titleLabel.font = UIFont.systemFont(ofSize: 40, weight: 10)
		titleLabel.textColor = .white

		subtitleLabel.text = "Take a photo of..."
		subtitleLabel.font = UIFont.systemFont(ofSize: 20, weight: 0.2)
		subtitleLabel.textColor = .white

		tableView.rowHeight = 64
		tableView.register(SubjectsTableViewCell.self, forCellReuseIdentifier: SubjectsTableViewCell.cellIdentifier)
		tableView.separatorStyle = .none
		tableView.backgroundColor = .clear

		layoutViews()
		setupRx()
	}

	private func layoutViews() {
		view.addSubview(titleLabel)
		view.addSubview(subtitleLabel)
		view.addSubview(tableView)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
			titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),

			subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
			subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),


			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
			tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
			])
	}

	private func setupRx() {
		viewModel.activeSubjects
			.asObservable()
			.bind(to: tableView.rx.items(
			cellIdentifier: SubjectsTableViewCell.cellIdentifier,
			cellType: SubjectsTableViewCell.self)
		) { (row, element, cell) in
			cell.subjectDescription = element.description
			cell.archived = element.archived
			cell.render()
			}
			.addDisposableTo(disposeBag)
	}
}
