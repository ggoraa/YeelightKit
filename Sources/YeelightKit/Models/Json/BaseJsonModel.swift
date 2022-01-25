//
//  BaseJsonModel.swift
//  
//
//  Created by Егор Яковенко on 10.12.2021.
//


struct BaseJsonModel<T: Codable>: Codable {
	let code: Int
	let message: String
	let result: T
}
