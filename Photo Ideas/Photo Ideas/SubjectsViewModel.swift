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
	private let subjectManager = SubjectManager.sharedInstance

	var activeSubjects: Observable<[Subject]> {
		return subjectManager.activeSubjects.asObservable()
	}

	var archivedSubjects: Driver<[Subject]> {
		return subjectManager.archivedSubjects.asDriver()
	}

	init(provider: RxMoyaProvider<PhotoIdeasAPI>) {
		self.provider = provider
		subjectManager.updateInMemoryModel()
		checkIfRequestNeeded()
	}

	func getNewSubjects() {
		let allSubjectsSortedById = (subjectManager.activeSubjects.value + subjectManager.archivedSubjects.value).sorted { (subA, subB) -> Bool in
			return subA.id > subB.id
		}
		getSubjects(id: allSubjectsSortedById.last?.id)
			.subscribe(onNext: { [weak self] (newSubjects) in
				newSubjects.forEach({ (subject) in
					self?.subjectManager.insert(subject: subject)
				})
			})
		.addDisposableTo(disposeBag)
	}

	func checkIfRequestNeeded() {
		subjectManager.completionTrigger
			.asObservable()
			.subscribe(onNext: { [weak self] (_) in
				guard let strongSelf = self else { return }
				guard strongSelf.subjectManager.activeSubjects.value.isEmpty else { return }
				strongSelf.getNewSubjects()
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
