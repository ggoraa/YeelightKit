//
//  DeviceListModel.swift
//  
//
//  Created by Егор Яковенко on 30.11.2021.
//

import Foundation

open class Device: Identifiable {
	public static func == (lhs: Device, rhs: Device) -> Bool {
		return lhs.deviceId == rhs.deviceId
	}
	
	let deviceId: String
	let name: String
	let model: DeviceModel
	let macAddress: String
	let longitude: Double
	let latitude: Double
	let isOnline: Bool
	let isOn: Bool
	
	init(deviceId: String, name: String, model: DeviceModel, macAddress: String, longitude: Double, latitude: Double, isOnline: Bool, isOn: Bool) {
		self.deviceId = deviceId
		self.name = name
		self.model = model
		self.macAddress = macAddress
		self.longitude = longitude
		self.latitude = latitude
		self.isOnline = isOnline
		self.isOn = isOn
	}
}
