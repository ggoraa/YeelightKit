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
			let longitude: String
			let latitude: String
			let isOnline: Bool
			
			func toPDevice() -> Device {
				return Device(deviceId: self.did, name: self.name, description: self.desc, model: self.model.toDeviceModel(), macAddress: self.mac, longitude: Double(self.longitude)!, latitude: Double(self.latitude)!, isOnline: self.isOnline)
			}
		}
		let list: [DeviceJsonModel]
	}
	let result: Results
}

public struct Device: Decodable, Hashable {
	public let deviceId: String
	public let name: String
	public let description: String
	public let model: DeviceModel
	public let macAddress: String
	public let longitude: Double
	public let latitude: Double
	public let isOnline: Bool
}
