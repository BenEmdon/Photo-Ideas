//
//  SubjectsViewModel.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-11.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import Moya
import Argo
import RxSwift
import RxCocoa

class SubjectsViewModel {
	private let provider: RxMoyaProvider<PhotoIdeasAPI>
	private let disposeBag = DisposeBag()
	let activeSubjects = ActiveSubjects.sharedInstance.subjects
	var lastId: String? = nil {
		didSet {
			UserDefaults.standard.set(lastId, forKey: "lastId")
		}
	}

	init(provider: RxMoyaProvider<PhotoIdeasAPI>) {
		self.provider = provider
		lastId = UserDefaults.standard.string(forKey: "lastId")

		activeSubjects.asObservable().subscribe(onNext: { [weak self] (subjects) in
				if subjects.isEmpty {
					self?.fetchSubjects()
				}
			})
			.addDisposableTo(disposeBag)
	}

	func fetchSubjects() {
		getSubjects(id: lastId)
			.subscribe(onNext: { [weak self] (subjects) in
				self?.activeSubjects.value = Set(subjects)
				self?.lastId = subjects
					.sorted { (subjectA, subjectB) -> Bool in
						return subjectA.id > subjectB.id
					}
					.filter{ !$0.archived }
					.first?.id
			})
			.addDisposableTo(disposeBag)
	}


	// network
	private func getSubjects(id: String?) -> Observable<[Subject]> {
		return provider.request(.subjects(id: id))
			.retry(2)
			.mapArray(type: Subject.self, keyPath: "subjects")
	}
}
