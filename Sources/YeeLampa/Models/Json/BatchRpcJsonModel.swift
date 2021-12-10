//
//  File.swift
//  A JSON model for parsing https://de.openapp.io.mi.com/openapp/home/batchrpc endpoint
//
//  Created by Егор Яковенко on 10.12.2021.
//

struct BatchRpcJsonModel: Codable {
	let code: Int
	let did: Int64
	let id: Int64
	let index: Int
	let otlocalts: Int64
	let result: [String]
}
