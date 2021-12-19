//
//  File.swift
//  
//
//  Created by Егор Яковенко on 19.12.2021.
//

public struct ColorFlow {
	public enum Action {
		case recoverToPreviousState
		case stayTheSame
		case shutDown
	}
	public struct FlowExpression {
		enum Mode: Int {
			case color = 1
			case colorTemperature = 2
			case sleep = 7
		}
		let duration: Int64
		let mode: Mode
		let value: (red: Int, green: Int, blue: Int)
		let brightness: Int?
	}
	/// Total number of visible state changing before color flow stopped. 0 means infinite loop on the state changing.
	let count: Int
	let action: Action
	let flow: [FlowExpression]
	
}
