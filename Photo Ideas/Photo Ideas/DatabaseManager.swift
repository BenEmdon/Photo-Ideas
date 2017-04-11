//
//  DatabaseManager.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-11.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import SQLite

class DatabaseManager {
	let path = NSSearchPathForDirectoriesInDomains(
		.documentDirectory, .userDomainMask, true
		).first!

	let db: Connection

	let subjects = Table("subjects")
	let sqlID = Expression<Int64>("sqlID")
	let id = Expression<String>("id")
	let descripion = Expression<String>("descripion")
	let archived = Expression<Bool>("archived")


	init() {
		db = try! Connection("\(path)/db.sqlite3")

		try! db.run(subjects.create { t in
			t.column(sqlID, primaryKey: true)
			t.column(id, unique: true)
			t.column(descripion, unique: true)
			t.column(archived)
		})
	}

	func insert(subject: Subject) -> Int64 {
		let insert = subjects.insert(id <- subject.id, descripion <- subject.description, archived <- false)
		return try! db.run(insert)
	}

	func getAllActiveSubjects() throws -> [Subject] {
		var activeSubjects = [Subject]()
		for subject in try db.prepare(subjects.filter(archived == false)) {
			activeSubjects.append(Subject(description: subject[descripion], score: nil, id: subject[id]))
		}
		return activeSubjects
	}

	func getAllInactiveSubjects() throws -> [Subject] {
		var inactiveSubjects = [Subject]()
		for subject in try db.prepare(subjects.filter(archived == true)) {
			inactiveSubjects.append(Subject(description: subject[descripion], score: nil, id: subject[id]))
		}
		return inactiveSubjects
	}

	func archive(subject: Subject) throws {
		try db.run(subjects.filter(id == subject.id).update(archived <- true))
	}
}
