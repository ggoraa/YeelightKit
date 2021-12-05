//
//  DeviceModel.swift
//  
//
//  Created by Егор Яковенко on 30.11.2021.
//

public enum DeviceModel: Decodable, Hashable {
	case LightStrip(Int, String)
	case DeskLamp(Int, String)
	case BedsideLamp(Int, String)
	case CeilingLamp(Int, String)
}

extension String {
	func toDeviceModel() -> DeviceModel {
		return DeviceModel.LightStrip(1, "yeelink.light.strip4")
	}
}
