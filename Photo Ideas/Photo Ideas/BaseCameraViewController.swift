//
//  BaseCameraViewController.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-11.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import UIKit
import SwiftyCam

class BaseCameraViewController: SwiftyCamViewController {

	let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)

	fileprivate var orderedViewControllers: [UIViewController]!

	override var prefersStatusBarHidden: Bool {
		return true
	}

	init() {
		super.init(nibName: nil, bundle: nil)
		orderedViewControllers = [
			UIViewController(),
			CameraControlViewController(swiftyCam: self)
		]
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		addChildViewController(pageViewController)
		view.addSubview(pageViewController.view)
		pageViewController.view.frame = view.bounds

		orderedViewControllers.first!.view.backgroundColor = .white
		orderedViewControllers.last!.view.backgroundColor = .clear

		pageViewController.dataSource = self

		pageViewController.setViewControllers([orderedViewControllers.last!], direction: .forward, animated: true)
	}
}

extension BaseCameraViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else { return nil }
		let previousIndex = viewControllerIndex - 1

		guard previousIndex >= 0,
			orderedViewControllers.count > previousIndex
			else { return nil }

		return orderedViewControllers[previousIndex]
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
			return nil
		}

		let nextIndex = viewControllerIndex + 1
		let orderedViewControllersCount = orderedViewControllers.count

		guard orderedViewControllersCount != nextIndex,
			orderedViewControllersCount > nextIndex
			else { return nil }

		return orderedViewControllers[nextIndex]
	}
}
