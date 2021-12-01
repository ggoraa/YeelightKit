//
//  DeviceListModel.swift
//  
//
//  Created by Егор Яковенко on 30.11.2021.
//

struct DeviceListJsonModel: Decodable {
	struct Results: Decodable {
		struct DeviceJsonModel: Decodable {
			let did: String
			let name: String
			let desc: String
			let model: String
			let mac: String
			let longitude: Double
			let latitude: Double
			let isOnline: Bool
			
			func toPDevice() -> Device {
				return Device(deviceId: self.did, name: self.name, description: self.desc, model: self.model.toDeviceModel(), macAddress: self.mac, longitude: self.longitude, latitude: self.latitude, isOnline: self.isOnline)
			}
		}
		let list: [DeviceJsonModel]
	}
	let result: Results
}

public struct Device: Decodable {
	let deviceId: String
	let name: String
	let description: String
	let model: DeviceModel
	let macAddress: String
	let longitude: Double
	let latitude: Double
	let isOnline: Bool
}
