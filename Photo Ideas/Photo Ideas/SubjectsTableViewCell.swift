//
//  SubjectsTableViewCell.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-11.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import UIKit

class SubjectsTableViewCell: UITableViewCell {

	var subjectDescription: String?
	var archived: Bool?

	private let descriptionLabel = UILabel()

	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		super.init(style: .default, reuseIdentifier: reuseIdentifier)

		backgroundColor = .white
		contentView.backgroundColor = UIColor.green.withAlphaComponent(0.3)

		descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: 0.2)
		descriptionLabel.textColor = .darkText

		let horizontalStackView = UIStackView(arrangedSubviews: [
			descriptionLabel,
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

		descriptionLabel.text = nil
		archived = nil
		contentView.backgroundColor = UIColor.white
	}

}
