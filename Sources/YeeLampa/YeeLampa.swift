import Foundation

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
	public init(accessToken: String, region: Region) throws {
		self.region = region
		self.accessToken = accessToken
		self.deviceListUrl = URL(string: "https://\(region.urlFormat).openapp.io.mi.com/openapp/user/device_list")!
		print(self.deviceListUrl)
	}
	
	/// Returns the device list.
	/// This function does not use a cache, it returns new data from the server.
	public func getDeviceList(completion: @escaping (Result<[Device], Error>) -> Void) {
		var request = URLRequest(url: self.deviceListUrl)
		request.httpMethod = "POST"
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		request.httpBody = Data("clientId=\(self.clientId)&accessToken=\(self.accessToken)".utf8)
		let requestTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
			print("in task")
			guard error == nil else {
				print("\(String(describing: error))")
				return completion(.failure(RequestError.badToken))
			}
			
			if let response = response as? HTTPURLResponse {
				print(response.statusCode)
				if (response.statusCode != 200) {
					print("Bad status code received from server: \(response.statusCode)")
				}
			}

			// Convert HTTP Response Data to a simple String
			guard data == nil else {
				print(String(data: data!, encoding: .utf8)!)
				let parsedData = try! JSONDecoder().decode(DeviceListJsonModel.self, from: data!)
				return completion(.success(parsedData.result.list))
			}
		}
		requestTask.resume()
	}
}
