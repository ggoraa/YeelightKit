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
	
	public func setPower(to on: Bool, for device: Device) async throws {
		try await self.sendDeviceRequest(
			url: URL(string: "https://\(self.region.urlFormat).openapp.io.mi.com/openapp/device/rpc/\(device.deviceId)")!,
			arguments: ["method": "set_power", "params": [on ? "on" : "off"]]
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
