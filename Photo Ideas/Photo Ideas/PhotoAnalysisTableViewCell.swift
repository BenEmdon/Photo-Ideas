//
//  PhotoAnalysisTableViewCell.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-11.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import UIKit

class PhotoAnalysisTableViewCell: UITableViewCell {

	var subjectDescription: String?
	var score: Float?
	var archived: Bool?

	private let descriptionLabel = UILabel()
	private let scoreLabel = UILabel()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)

		backgroundColor = .white
		contentView.backgroundColor = UIColor.green.withAlphaComponent(0.3)

		descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: 0.2)
		descriptionLabel.textColor = .darkText
		scoreLabel.font = UIFont.systemFont(ofSize: 20, weight: 0.2)
		scoreLabel.textAlignment = .right

		let horizontalStackView = UIStackView(arrangedSubviews: [
			descriptionLabel,
			scoreLabel
			])
		horizontalStackView.axis = .horizontal
		horizontalStackView.alignment = .center

		horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(horizontalStackView)

		NSLayoutConstraint.activate([
			horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
			horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
			horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
			])
	}

	func render() {
		descriptionLabel.text = subjectDescription

		if let score = score {
			scoreLabel.text = "%\(String(format: "%.0f", score * 100))"
			scoreLabel.textColor = score > 0.8 ? .green : score > 0.5 ? .orange : .red
		}

		if let archived = archived, archived {
			contentView.backgroundColor = UIColor.green.withAlphaComponent(0.3)
		} else {
			contentView.backgroundColor = UIColor.white
		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		subjectDescription = nil
		score = nil

		descriptionLabel.text = nil
		scoreLabel.text = nil
		scoreLabel.textColor = .clear
		archived = nil
		contentView.backgroundColor = UIColor.white
	}
}
