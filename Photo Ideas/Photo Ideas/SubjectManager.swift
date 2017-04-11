//
//  SubjectManager.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-11.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import RxSwift
import SQLite

class SubjectManager {
	static let sharedInstance = SubjectManager()

	let activeSubjects = Variable<Array<Subject>>([])
	let archivedSubjects = Variable<Array<Subject>>([])
	let completionTrigger = Variable<Bool>(false) // for first round capture of elements
	let databaseManager = DatabaseManager()

	let disposeBag = DisposeBag()

	func updateInMemoryModel() {
		let activeSubjectsObservable = Observable<[Subject]>.create { [weak self] (o) -> Disposable in
			DispatchQueue.global(qos: .background).async {
				do {
					guard let task = try self?.databaseManager.getAllActiveSubjects() else { return }
					o.onNext(task)
				} catch let error {
					o.onError(error)
				}
				o.onCompleted()
			}
			return Disposables.create { }
		}

		activeSubjectsObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (activeSubjects) in
				self?.activeSubjects.value = activeSubjects
				}, onError: { (error) in
					print(error)
			}, onCompleted: { [weak self] _ in
				self?.completionTrigger.value = true
			})
			.addDisposableTo(disposeBag)

		let archivedSubjectsObservable = Observable<[Subject]>.create { [weak self] (o) -> Disposable in
			DispatchQueue.global(qos: .background).async {
				do {
					guard let task = try self?.databaseManager.getAllActiveSubjects() else { return }
					o.onNext(task)
				} catch let error {
					o.onError(error)
				}
				o.onCompleted()
			}
			return Disposables.create { }
		}

		archivedSubjectsObservable
			.observeOn(MainScheduler.instance)
			.subscribe(onNext: { [weak self] (archivedSubjects) in
				self?.activeSubjects.value = archivedSubjects
				}, onError: { (error) in
					print(error)
			})
			.addDisposableTo(disposeBag)
	}

	func insert(subject: Subject) {
		DispatchQueue.global(qos: .background).async { [weak self] in
			_ = self?.databaseManager.insert(subject: subject)
			self?.updateInMemoryModel()
		}
	}

	func archive(subject: Subject) {
		DispatchQueue.global(qos: .background).async { [weak self] in
			try! self?.databaseManager.archive(subject: subject)
			self?.updateInMemoryModel()
		}
	}

}
