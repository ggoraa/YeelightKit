//
//  Region.swift
//  
//
//  Created by Егор Яковенко on 28.11.2021.
//

public enum Region {
	case Germany
	case Russia
	
	var urlFormat: String {
		switch self {
			case .Germany: return "de"
			case .Russia: return "ru"
		}
	}
}
