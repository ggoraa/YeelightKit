import Foundation
import Requester

/// Main class of YeeLampa.
public class YeeLampa {
	private let clientId = 2882303761517308695
	private let clientSecret = "OrwZHJ/drEXakH1LsfwwqQ=="
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
	
	/// Returns the device list.
	/// This function does not use a cache, it returns new data from the server.
	public func getDeviceList(completion: @escaping (Result<[Device], Error>) -> Void) {
		var request = URLRequest(url: self.deviceListUrl)
		request.httpMethod = "POST"
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = Data("clientId=\(self.clientId)&accessToken=\(self.accessToken)".utf8)
		let requestTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
			guard error == nil else {
				return completion(.failure(RequestError.badToken))
			}
			
			if let response = response as? HTTPURLResponse {
				if (response.statusCode != 200) {
					return completion(.failure(RequestError.unexpectedResponseCode(response.statusCode)))
				}
			}

			// Convert HTTP Response Data to a simple String
			guard data == nil else {
				print(String(data: data!, encoding: .utf8))
				let parsedData = try! JSONDecoder().decode(BaseDeviceListJsonModel.self, from: data!)
				return completion(.success(parsedData.result.list.map { device in
					return device.toPDevice()
				}))
			}
		}
		requestTask.resume()
	}
	
	public func toggle(device: Device, on: Bool) {
		var param = ""
		if on {
			param = "on"
		} else {
			param = "off"
		}
		self.sendRequestTo(device: device, arguments: ["method": "set_power", "params": [param]]) { result in
			
		}
	}
	
	private func sendRequestTo(device: Device, arguments: [String: Any], _ completion: @escaping (Result<[Device], Error>) -> Void) {
		do {
			let payload = try JSONSerialization.data(withJSONObject: arguments, options: .prettyPrinted)
			Requester.shared.sendDataRequest(
				url: URL(string: "https://\(self.region.urlFormat).openapp.io.mi.com/openapp/device/rpc/\(device.deviceId)")!,
				method: .post,
				body: "clientId=\(self.clientId)&accessToken=\(self.accessToken)&data=\(String(data: payload, encoding: .utf8)!.replacingOccurrences(of: "\n", with: ""))",
				headers: ["Content-Type": "application/x-www-form-urlencoded"],
				completion: { (_: String) in
					
				}, failure: { error in
					return completion(.failure(RequestError.badToken))
				}
			)
		} catch {
			print(error.localizedDescription)
		}
	}
}
