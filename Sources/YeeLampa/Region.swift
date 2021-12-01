//
//  Region.swift
//  
//
//  Created by Егор Яковенко on 28.11.2021.
//

public enum Region {
	case Germany
	
	var urlFormat: String {
		switch self {
			case .Germany: return "de"
		}
	}
}
