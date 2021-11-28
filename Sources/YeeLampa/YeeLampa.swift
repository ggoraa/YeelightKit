import Foundation
/// Main class of YeeLampa.
public class YeeLampa {
	private let clientId = "2882303761517308695"
	private let clientSecret = "OrwZHJ/drEXakH1LsfwwqQ=="
	private let region: Region
	private let accessToken: String
	private let deviceListUrl = URL(string: "https://\(region.urlFormat).openapp.io.mi.com/openapp/user/device_list")
	
	/// Creates a YeeLampa instance with provided credentials.
	/// - Parameters:
	/// 	- accessToken: The token you acquired when logging in.
	/// 	- region: The region we will connect to.
	public init(accessToken: String, region: Region) throws {
		self.region = region
		self.accessToken = accessToken
		var request = URLRequest(url: deviceListUrl!)
		request.httpMethod = "GET"
		request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

			// Check if Error took place
			if let error = error {
				throw InitError.logInFailure(description: error.text)
			}

			// Read HTTP Response Status code
			if let response = response as? HTTPURLResponse {
				if (response.statusCode != 200) {
					throw InitError.logInFailure(description: "Bad status code received from server: \(response.statusCode)")
				}
			}

			// Convert HTTP Response Data to a simple String
			if let data = data, let dataString = String(data: data, encoding: .utf8) {
				print("Response data string:\n \(dataString)")
			}

		}
		task.resume()
	}
}
