import Foundation
import Alamofire

/// Main class of YeeLampa.
public class YeeLampa {
	public static let clientId = 2882303761517308695
	public static let clientSecret = "OrwZHJ/drEXakH1LsfwwqQ=="
	private var region: Region
	private var accessToken: String
	private let deviceListUrl: URL
	
	/// Creates a YeeLampa instance with provided credentials.
	/// - Parameters:
	/// 	- accessToken: The token you acquired when logging in.
	/// 	- region: The region we will connect to.
	public init(accessToken: String, region: Region) {
		self.region = region
		self.accessToken = accessToken
		self.deviceListUrl = URL(string: "https://\(region.urlFormat).openapp.io.mi.com/openapp/user/device_list")!
	}
	
	private struct AuthResponse: Codable {
		let access_token: String
	}
	
	/// Converts an authorization grant to a usable access token.
	/// - Parameters:
	/// 	- grant: A grant to convert.
	public static func convertAuthGrantToToken(_ grant: String) async throws -> String {
		let url = URL(string: "https://account.xiaomi.com/oauth2/token")!
		let task = AF.request(
			url,
			method: .get,
			parameters: [
				"client_id": YeeLampa.clientId,
				"client_secret": YeeLampa.clientSecret,
				"grant_type": "authorization_code",
				"redirect_uri": "http://www.mi.com",
				"code": grant
			],
			headers: [
				"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/92.0.4495.0 Safari/537.36"
			]
		).serializingString()
		do {
			let response = try await task.value
			let validJson = response.replacingOccurrences(of: "&&&START&&&", with: "")
			return try! JSONDecoder().decode(AuthResponse.self, from: Data(validJson.utf8)).access_token
		} catch {
			throw LoginError.unknownError
		}
	}
	
	/// Returns the device list.
	/// This function does not use a cache, it returns new data from the server.
	public func getDeviceList() async throws -> [Device] {
		var request = URLRequest(url: self.deviceListUrl)
		request.httpMethod = "POST"
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = Data("clientId=\(YeeLampa.clientId)&accessToken=\(self.accessToken)".utf8)
		
		let task = AF.request(self.deviceListUrl, method: .post, parameters: [
			"clientId": YeeLampa.clientId,
			"accessToken": self.accessToken
		], headers: [
			"Content-Type": "application/x-www-form-urlencoded"
		]).serializingDecodable(BaseJsonModel<DeviceListJsonModel>.self)
		return try await task.value.result.list.map { device in
			return device.toPDevice()
		}
	}
	
	/// Set a color temperature for a device that supports it.
	/// - Parameters:
	///   - temp: A target temperature.
	///   - effect: An effect that wiil be used.
	///   - duration: Time that it will take.
	///   - device: A target device.
	public func setColorTemperature(to temp: Int,  withEffect effect: ChangeEffect = .smooth, withDuration duration: Int = 500, for device: Device) async throws {
		try await modifyDeviceState(deviceId: device.deviceId, method: "set_ct_abx", params: [temp, effect.rawValue, duration])
	}
	
	/// Sets power state for a device.
	/// - Parameters:
	///   - on: The power state you want your device to change to.
	///   - effect: An effect that wiil be used.
	///   - duration: Time that it will take.
	///   - device: A target device.
	public func setPower(to on: Bool,  withEffect effect: ChangeEffect = .smooth, withDuration duration: Int = 500, for device: Device) async throws {
		try await modifyDeviceState(deviceId: device.deviceId, method: "set_power", params: [(on ? "on" : "off"), effect.rawValue, duration])
	}
	
	/// Toggles an LED.
	/// - Parameter device: A target device.
	public func togglePower(ofDevice device: Device) async throws {
		try await modifyDeviceState(deviceId: device.deviceId, method: "toggle", params: [])
	}
	
	/// Sets an RGB color.
	/// - Parameters:
	///   - color: A RGB color you want to set.
	///   - effect: An effect that wiil be used.
	///   - duration: Time that it will take.
	///   - device: A target device.
	public func setRgbColor(
		of color: (
			red: Int,
			green: Int,
			blue: Int
		),
		withEffect effect: ChangeEffect = .smooth,
		withDuration duration: Int = 500,
		for device: Device
	) async throws {
		try await modifyDeviceState(deviceId: device.deviceId, method: "set_rgb", params: [
			((color.red << 16) + (color.green << 8) + color.blue),
			effect.rawValue,
			duration]
		)
	}
	
	/// Sets an HSV color.
	/// - Parameters:
	///   - color: A color you want to set. `hue`'s bounds are 0 to 359(yea, it's strange, but this is how the API works),  `saturation` is from 0 to 100, and `brightness` is from 0 to 100. Note that if a `brightness` value is provided, then there will be 2 requests, one to set the `hue` and `saturation`, and one for `brightness`. Don't blame me on this design, this is how the API works! :D
	///   - effect: An effect that wiil be used.
	///   - duration: Time that it will take.
	///   - device: A target device.
	public func setHsvColor(
		of color: (
			hue: Int,
			saturation: Int
		),
		withEffect effect: ChangeEffect = .smooth,
		withDuration duration: Int = 500,
		for device: Device
	) async throws {
		try await modifyDeviceState(deviceId: device.deviceId, method: "set_hsv", params: [color.hue, color.saturation, effect.rawValue, duration])
	}
	
	
	/// Sets the brightness of a device.
	/// - Parameters:
	///   - value: A brightness value you want to set. Allowed values are from 0 to 100.
	///   - effect: An effect that wiil be used.
	///   - duration: Time that it will take.
	///   - device: A target device.
	public func setBrightness(to value: Int, withEffect effect: ChangeEffect = .smooth, withDuration duration: Int = 500, for device: Device) async throws {
		try await modifyDeviceState(deviceId: device.deviceId, method: "set_bright", params: [value, effect.rawValue, duration])
	}
	
	private func modifyDeviceState(deviceId: String, method: String, params: Array<Any>) async throws {
		let _ = try await self.sendDeviceRequest(
			url: URL(string: "https://\(self.region.urlFormat).openapp.io.mi.com/openapp/device/rpc/\(deviceId)")!,
			arguments: ["method": method, "params": params]
		)
	}
	
	/// An internal function to pass requests to devices.
	/// - Parameters:
	///   - url: A url to call when making a request.
	///   - arguments: JSON arguments that will be stuffid in the request.
	/// - Returns: A response in Data type.
	private func sendDeviceRequest(url: URL, arguments: [String: Any]) async throws -> Data {
		do {
			let payload = try JSONSerialization.data(withJSONObject: arguments)
			let task = AF.request(
				url,
				method: .post,
				parameters: [
					"clientId": YeeLampa.clientId,
					"accessToken": self.accessToken,
					"data": String(data: payload, encoding: .utf8)!.replacingOccurrences(of: "\n", with: "")
				],
				headers: ["Content-Type": "application/x-www-form-urlencoded"]
			).serializingData()
			return try await task.value
		} catch {
			throw RequestError.badToken
		}
	}
}
