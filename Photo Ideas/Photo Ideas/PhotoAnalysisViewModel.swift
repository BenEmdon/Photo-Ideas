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
import RxCocoa

struct PhotoAnalysisViewModel {
	private let provider: RxMoyaProvider<PhotoIdeasAPI>
	private let imageData: Data
	private let disposeBag = DisposeBag()

	init(imageData: Data, provider: RxMoyaProvider<PhotoIdeasAPI>) {
		self.imageData = imageData
		self.provider = provider
	}

	func getSubjectsForImage() -> Observable<[Subject]> {
		return requestSubjects(forImageData: imageData)
	}

	// network
	private func requestSubjects(forImageData imageData: Data) -> Observable<[Subject]> {
		return provider.request(.image(data: imageData))
			.retry(2)
			.mapArray(type: Subject.self, keyPath: "subjects")
	}
}
