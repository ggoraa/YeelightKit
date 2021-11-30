//
//  File.swift
//  
//
//  Created by Егор Яковенко on 30.11.2021.
//

struct DeviceListJsonModel: Decodable {
	struct Results: Decodable {
		let list: [Device]
	}
	let result: Results
}

public struct Device: Decodable {
	let did: String
	let name: String
	let model: String
	let mac: String
}
