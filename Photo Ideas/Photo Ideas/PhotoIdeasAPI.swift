//
//  PhotoIdeasAPI.swift
//  Photo Ideas
//
//  Created by Benjamin Emdon on 2017-04-10.
//  Copyright © 2017 Benjamin Emdon. All rights reserved.
//

import Foundation
import Moya


/// The TargetType for a HTTPS custom endpoint
///
/// - image: the image route
/// - subjects: the subjects route
enum PhotoIdeasAPI {
	case image(data: Data)
	case subjects(id: String?)
}

extension PhotoIdeasAPI: TargetType {

	var baseURL: URL { return URL(string: "https://photo-ideas-backend.herokuapp.com")! }

	var path: String {
		switch self {
		case .image(_):
			return "/image"
		case .subjects(let id):
			if let id = id {
				return "/subjects/\(id)"
			} else {
				return "/subjects"
			}
		}
	}

	var method: Moya.Method {
		switch self {
		case .image(_):
			return .post
		case .subjects(_):
			return .get
		}
	}

	var parameters: [String : Any]? {
		switch self {
		case .image(let data):
			return [
				"image": data.base64EncodedString()
			]
		case .subjects(_):
			return nil
		}
	}

	var parameterEncoding: ParameterEncoding {
		return JSONEncoding.default
	}

	var task: Task {
		return .request
	}

	var sampleData: Data {
		return "".data(using: .utf8)! // TODO implement fixtures for tests
	}
}
