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

struct SubjectsViewModel {
	private let provider: RxMoyaProvider<PhotoIdeasAPI>
	private let disposeBag = DisposeBag()

	var lastId: String?

	init(provider: RxMoyaProvider<PhotoIdeasAPI>) {
		self.provider = provider
	}

	// network
	private func getSubjects(id: String?) -> Observable<[Subject]> {
		return provider.request(.subjects(id: id))
			.retry(2)
			.mapArray(type: Subject.self, keyPath: "subjects")
	}
}
