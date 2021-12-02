//
//  QueryString.swift
//  
//
//  Created by Егор Яковенко on 01.12.2021.
//

extension Dictionary {
	var queryString: String {
		var output: String = ""
		for (key,value) in self {
			output +=  "\(key)=\(value)&"
		}
		output = String(output.dropLast())
		return output
	}
}
