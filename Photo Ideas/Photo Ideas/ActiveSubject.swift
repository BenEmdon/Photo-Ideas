//
//  ActiveSubject.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-11.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import RxSwift

/// Global subjects set to be managed and observed by anyone (thread safe)
struct ActiveSubjects {
	static let sharedInstance = ActiveSubjects()
	let subjects = Variable<Set<Subject>>([])
}
