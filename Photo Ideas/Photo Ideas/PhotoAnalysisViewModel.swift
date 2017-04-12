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

/// PhotoAnalysisViewModel controls all the logic related to PhotoAnalysisViewCOntroller
struct PhotoAnalysisViewModel {

	/// Moya provider allows for simple abstracted networking
	private let provider: RxMoyaProvider<PhotoIdeasAPI>
	private let imageData: Data
	private let activeSubjects = ActiveSubjects.sharedInstance.subjects

	init(imageData: Data, provider: RxMoyaProvider<PhotoIdeasAPI>) {
		self.imageData = imageData
		self.provider = provider
	}

	/// Gets the subjects for the current imageData and uses set theory to get the intersect between the incoming set of subjects and the current active subjects.
	/// Modifies the current active subjects by marking the intersecting subjects as archived
	func getSubjectsForImage() -> Observable<Set<Subject>> {
		return requestSubjects(forImageData: imageData)
		.map { (subjects) in
			let intersection = self.activeSubjects.value.intersection(subjects)
			let archivedIntersection = intersection.map { (subject) -> (Subject) in
				return Subject(description: subject.description, score: subject.score, id: subject.id, archived: true)
			}

			self.activeSubjects.value = Set(archivedIntersection).union(self.activeSubjects.value)

			let inactiveSubjects = Set(subjects).subtracting(self.activeSubjects.value)
			return Set(archivedIntersection).union(inactiveSubjects)
		}
	}

	/// Makes a POST request to the PhotoIdeasAPI, retrying twice if the request fails, and returns an array of Subjects
	private func requestSubjects(forImageData imageData: Data) -> Observable<[Subject]> {
		return provider.request(.image(data: imageData))
			.retry(2)
			.mapArray(type: Subject.self, keyPath: "subjects")
	}
}
