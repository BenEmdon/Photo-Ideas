//
//  PeopleViewController.swift
//  FaceDex
//
//  Created by Benjamin Emdon on 2017-02-04.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import Moya
import RxSwift
import RxCocoa

class PhotoAnalysisViewController: UIViewController {

	override var prefersStatusBarHidden: Bool {
		return true
	}

	private let backgroundImage: UIImage
	private let activityIndicator = UIActivityIndicatorView()
	private let tableView = UITableView()
	private let imageData: Data
	private let disposeBag = DisposeBag()

	init(image: UIImage) {
		imageData = UIImageJPEGRepresentation(image.resizeWith(percentage: 0.4)!, 0.4)!
		
		backgroundImage = UIImage(data: imageData)!
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		let backgroundImageView = UIImageView(frame: view.bounds)
		backgroundImageView.image = backgroundImage

		let cancelButton = UIButton(frame: CGRect(x: 10.0, y: 10.0, width: 30.0, height: 30.0))
		cancelButton.setImage(#imageLiteral(resourceName: "cancel"), for: UIControlState())
		cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)

		tableView.frame = view.bounds
		tableView.backgroundColor = .clear
		tableView.contentInset = UIEdgeInsets(top: view.bounds.height - 64, left: 0, bottom: 0, right: 0)
		tableView.rowHeight = 64
		tableView.separatorStyle = .none
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.cellIdentifier)

		activityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
		activityIndicator.center = view.center
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge

		view.addSubview(backgroundImageView)
		view.addSubview(tableView)
		view.addSubview(activityIndicator)
		view.addSubview(cancelButton)

		activityIndicator.startAnimating()

		setupRx()
	}

	func setupRx() {
		let provider = RxMoyaProvider<PhotoIdeasAPI>()
		let viewModel = PhotoAnalysisViewModel(imageData: imageData, provider: provider)

		viewModel.getSubjectsForImage()
			.do(onDispose: { [weak self] in
				self?.activityIndicator.stopAnimating()
			})
			.bind(to: tableView.rx.items(
				cellIdentifier: UITableViewCell.cellIdentifier,
				cellType: UITableViewCell.self)
			) { (row, element, cell) in
				cell.textLabel?.text = element.description
			}
			.addDisposableTo(disposeBag)
	}

	func cancel() {
		dismiss(animated: true, completion: nil)
	}
}

