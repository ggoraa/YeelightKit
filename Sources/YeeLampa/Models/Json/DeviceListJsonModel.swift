//
//  BaseDeviceListJsonModel.swift
//  
//
//  Created by Егор Яковенко on 06.12.2021.
//

struct DeviceListJsonModel: Codable {
	struct DeviceJsonModel: Codable {
		let did: String
		let name: String
		let desc: String
		let model: String
		let mac: String
		let longitude: String
		let latitude: String
		let isOnline: Bool
		
		func toPDevice() -> Device {
			return Device(deviceId: self.did, name: self.name, description: self.desc, model: self.model.toDeviceModel(), macAddress: self.mac, longitude: Double(self.longitude)!, latitude: Double(self.latitude)!, isOnline: self.isOnline)
		}
	}
	let list: [DeviceJsonModel]
}
