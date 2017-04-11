//
//  SubjectManager.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-11.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import RxSwift
import SQLite

struct SubjectManager {
	static let sharedInstance = SubjectManager()

	let activeSubjects = Variable<Set<Subject>>([])
	let archivedSubjects = Variable<Set<Subject>>([])
	

	init() {
		
	}

	func archive(subject: Subject) -> Bool {
		guard let removedSubject = activeSubjects.value.remove(subject) else { return false }
		let (inserted, _) = archivedSubjects.value.insert(removedSubject)
		return inserted
	}

}
