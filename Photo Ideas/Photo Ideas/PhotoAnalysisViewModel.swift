//
//  PhotoAnalysisViewModel.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-10.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import Moya
import Argo
import RxSwift

struct PhotoAnalysisViewModel {
	private let provider: RxMoyaProvider<PhotoIdeasAPI>
	private let imageData: Data
	private let disposeBag = DisposeBag()
	private let activeSubjects = ActiveSubjects.sharedInstance.subjects
	private var activeSubjectsSet: Set<Subject> {
		return Set(activeSubjects.value)
	}

	init(imageData: Data, provider: RxMoyaProvider<PhotoIdeasAPI>) {
		self.imageData = imageData
		self.provider = provider
	}

	func getSubjectsForImage() -> Observable<Set<Subject>> {
		return requestSubjects(forImageData: imageData)
		.map { (subjects) in
			let intersection = self.activeSubjectsSet.intersection(subjects)
			let archivedIntersection = intersection.map { (subject) -> (Subject) in
				return Subject(description: subject.description, score: subject.score, id: subject.id, archived: true)
			}

			self.activeSubjects.value = Set(archivedIntersection).union(self.activeSubjects.value)

			let inactiveSubjects = Set(subjects).subtracting(self.activeSubjects.value)
			return Set(archivedIntersection).union(inactiveSubjects)
		}
	}

	// network
	private func requestSubjects(forImageData imageData: Data) -> Observable<[Subject]> {
		return provider.request(.image(data: imageData))
			.retry(2)
			.mapArray(type: Subject.self, keyPath: "subjects")
	}
}
