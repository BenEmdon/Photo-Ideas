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

/// SubjectsViewModel controls all the logic related to the SubjectsViewCntroller
class SubjectsViewModel {

	private let provider: RxMoyaProvider<PhotoIdeasAPI>
	private let disposeBag = DisposeBag()
	private let modelSelected: ControlEvent<Subject>
	let activeSubjects = ActiveSubjects.sharedInstance.subjects

	/// The last id to query for subjects
	/// saves the id to UserDefaults
	var lastId: String? = nil {
		didSet {
			UserDefaults.standard.set(lastId, forKey: "lastId")
		}
	}

	init(provider: RxMoyaProvider<PhotoIdeasAPI>, modelSelected: ControlEvent<Subject>) {
		self.provider = provider
		self.modelSelected = modelSelected

		lastId = UserDefaults.standard.string(forKey: "lastId")

		// subscribes to the active subjects and fetches more when there are none left
		activeSubjects.asObservable()
			.subscribe(onNext: { [weak self] (subjects) in
				if subjects.filter({ !$0.archived }).isEmpty {
					self?.fetchSubjects()
				}
			})
			.addDisposableTo(disposeBag)

		// subscribes to table selections and removes a subject from the active subjects when the subject is selected
		modelSelected.subscribe(onNext: { (subject) in
			guard !subject.archived else { return }
				self.activeSubjects.value.remove(subject)
			})
			.addDisposableTo(disposeBag)
	}

	/// fetches subjects on invocation and detemines which id (if any) to query
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


	/// Makes a GET request to the PhotoIdeasAPI, retrying twice if the request fails, and returns an array of Subjects
	private func getSubjects(id: String?) -> Observable<[Subject]> {
		return provider.request(.subjects(id: id))
			.retry(2)
			.mapArray(type: Subject.self, keyPath: "subjects")
	}
}
