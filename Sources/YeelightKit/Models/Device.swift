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
	
	public let deviceId: String
	public let name: String
	public let model: DeviceModel
	public let macAddress: String
	public let longitude: Double
	public let latitude: Double
	public let isOnline: Bool
	public let isOn: Bool
	
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
