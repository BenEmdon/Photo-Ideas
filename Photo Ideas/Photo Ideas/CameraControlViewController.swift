//
//  CameraControlViewController.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-02-04.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import UIKit
import SwiftyCam

class CameraControlViewController: UIViewController {

	var flipCameraButton: UIButton!
	var flashButton: UIButton!
	var captureButton: SwiftyRecordButton!

	weak var swiftyCam: SwiftyCamViewController?

	init(swiftyCam: SwiftyCamViewController) {
		self.swiftyCam = swiftyCam
		super.init(nibName: nil, bundle: nil)
		swiftyCam.cameraDelegate = self
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		addButtons()
		swiftyCam?.cameraDelegate = self
		swiftyCam?.addGestureRecognizersTo(view: view)
	}

	private func addButtons() {
		captureButton = SwiftyRecordButton(
			frame: CGRect(
				x: view.frame.midX - 37.5,
				y: view.frame.height - 100.0,
				width: 75.0,
				height: 75.0
			)
		)
		view.addSubview(captureButton)
		captureButton.delegate = swiftyCam

		flipCameraButton = UIButton(
			frame: CGRect(
				x: (((view.frame.width / 2 - 37.5) / 2) - 15.0),
				y: view.frame.height - 74.0,
				width: 30.0,
				height: 23.0
			)
		)
		flipCameraButton.setImage(#imageLiteral(resourceName: "flipCamera"), for: UIControlState())
		flipCameraButton.addTarget(self, action: #selector(cameraSwitchAction(_:)), for: .touchUpInside)
		view.addSubview(flipCameraButton)

		let test = CGFloat((view.frame.width - (view.frame.width / 2 + 37.5)) +	((view.frame.width / 2) - 37.5) - 9.0)

		flashButton = UIButton(
			frame: CGRect(
				x: test,
				y: view.frame.height - 77.5,
				width: 18.0,
				height: 30.0
			)
		)
		flashButton.setImage(#imageLiteral(resourceName: "flashOutline"), for: UIControlState())
		flashButton.addTarget(self, action: #selector(toggleFlashAction(_:)), for: .touchUpInside)
		view.addSubview(flashButton)
	}

	@objc private func cameraSwitchAction(_ sender: Any) {
		swiftyCam?.switchCamera()
	}

	@objc private func toggleFlashAction(_ sender: Any) {
		guard let swiftyCam = swiftyCam else { return }
		swiftyCam.flashEnabled = !swiftyCam.flashEnabled

		flashButton.setImage(swiftyCam.flashEnabled ? #imageLiteral(resourceName: "flash"): #imageLiteral(resourceName: "flashOutline"), for: UIControlState())
	}
}

extension CameraControlViewController: SwiftyCamViewControllerDelegate {

	func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake photo: UIImage) {
		let newVC = PhotoAnalysisViewController(image: photo)
		present(newVC, animated: false, completion: nil)
	}

	func swiftyCam(_ swiftyCam: SwiftyCamViewController, didFocusAtPoint point: CGPoint) {
		let focusView = UIImageView(image: #imageLiteral(resourceName: "focus"))
		focusView.center = point
		focusView.alpha = 0.0
		view.addSubview(focusView)

		UIView.animate(
			withDuration: 0.25,
			delay: 0.0,
			options: .curveEaseInOut,
			animations: {
				focusView.alpha = 1.0
				focusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
		},
			completion: { (success) in
				UIView.animate(
					withDuration: 0.15,
					delay: 0.5,
					options: .curveEaseInOut,
					animations: {
						focusView.alpha = 0.0
						focusView.transform = CGAffineTransform(translationX: 0.6, y: 0.6)
				}, completion: { (success) in
					focusView.removeFromSuperview()
				})
		})
	}

	func swiftyCam(_ swiftyCam: SwiftyCamViewController, didChangeZoomLevel zoom: CGFloat) {
		print(zoom)
	}

	func swiftyCam(_ swiftyCam: SwiftyCamViewController, didSwitchCameras camera: SwiftyCamViewController.CameraSelection) {
		print(camera)
	}
}


