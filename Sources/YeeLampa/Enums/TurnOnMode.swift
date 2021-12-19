//
//  TurnOnMode.swift
//  
//
//  Created by Егор Яковенко on 19.12.2021.
//

/// Modes available when turning on a device.
public enum TurnOnMode: Int {
	/// Normal turn on operation (default value).
	case normal = 0
	/// Turn on and switch to CT mode.
	case colorTemperature = 1
	/// Turn on and switch to RGB mode.
	case rgb = 2
	/// Turn on and switch to HSV mode.
	case hsv = 3
	/// Turn on and switch to color flow mode.
	case colorFlow = 4
	/// Turn on and switch to Night light mode. (Ceiling light only).
	case nightLight = 5
}
