//
//  File.swift
//  
//
//  Created by Егор Яковенко on 18.12.2021.
//

public enum ChangeEffect {
	case sudden
	case smooth
	
	var rawValue: String {
		switch self {
			case .sudden:
				return "sudden"
			case .smooth:
				return "smooth"
		}
	}
}
