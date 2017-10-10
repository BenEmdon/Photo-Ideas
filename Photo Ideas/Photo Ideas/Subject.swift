//
//  Subject.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-10.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import Argo
import Runes
import Curry

/// Subject model that hosts all subject related information
struct Subject {
	let description: String
	let score: Float?
	let id: String
	let archived: Bool

	init(description: String, score: Float?, id: String) {
		self.description = description
		self.score = score
		self.id = id
		archived = false
	}

	init(description: String, score: Float?, id: String, archived: Bool) {
		self.description = description
		self.score = score
		self.id = id
		self.archived = archived
	}
}

// MARK: - Subject adopts the Decodable protocol. Argo is an object mapper that uses Runes (the <^> <*> <*> syntax) to turn JSON into strongly typed objects
extension Subject: Argo.Decodable {
	static func decode(_ json: JSON) -> Decoded<Subject> {
		return curry(self.init)
		<^> json <| "description"
		<*> json <|? "score"
		<*> json <| "_id"
	}
}

extension Subject: Equatable {
	public static func ==(lhs: Subject, rhs: Subject) -> Bool {
		return lhs.id == rhs.id && lhs.description == rhs.description
	}
}

extension Subject: Hashable {
	var hashValue: Int {
		return "\(id)_\(description)".hashValue
	}
}
