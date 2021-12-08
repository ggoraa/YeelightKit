//
//  DeviceListModel.swift
//  
//
//  Created by Егор Яковенко on 30.11.2021.
//

public struct Device: Decodable, Hashable, Equatable {
	public let deviceId: String
	public let name: String
	public let description: String
	public let model: DeviceModel
	public let macAddress: String
	public let longitude: Double
	public let latitude: Double
	public let isOnline: Bool
}
