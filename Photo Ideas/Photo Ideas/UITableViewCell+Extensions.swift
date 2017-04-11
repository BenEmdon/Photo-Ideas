//
//  UITableViewCell+Extensions.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-10.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import UIKit

extension UITableViewCell {
	static var cellIdentifier: String {
		return String(describing: self)
	}
}
