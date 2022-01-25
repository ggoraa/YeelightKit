//
//  DeviceModel.swift
//  
//
//  Created by Егор Яковенко on 30.11.2021.
//

public enum DeviceModel: Hashable, Equatable {
	case LightStrip(Int, String)
	case DeskLamp(Int, String)
	case BedsideLamp(Int, String)
	case CeilingLamp(Int, String)
}

extension String {
	func toDeviceModel() -> DeviceModel {
		// just a placeholder to be implemented later
		return DeviceModel.LightStrip(1, "yeelink.light.strip4")
	}
}
