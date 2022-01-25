//
//  ColorFlowExpression.swift
//  
//
//  Created by Егор Яковенко on 19.12.2021.
//

public enum ColorFlowExpression {
	case color(duration: Int, value: (red: Int, green: Int, blue: Int), brightness: Int?)
	case colorTemperature(duration: Int, value: (red: Int, green: Int, blue: Int), brightness: Int?)
	case sleep(duration: Int, value: (red: Int, green: Int, blue: Int))
}
