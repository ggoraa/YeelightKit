import Foundation
/// Main class of YeeLampa.
public class YeeLampa {
	private let clientId = "2882303761517308695"
	private let clientSecret = "OrwZHJ/drEXakH1LsfwwqQ=="
	private let region: Region
	private let accessToken: String
	private let deviceListUrl = URL(string: "https://de.openapp.io.mi.com/openapp/user/device_list")
	
	/// Creates a YeeLampa instance with provided credentials.
	/// - Parameters:
	/// 	- accessToken: The token you acquired when logging in.
	/// 	- region: The region we will connect to.
	public init(accessToken: String, region: Region) {
		self.region = region
		self.accessToken = accessToken
	}
	
	public enum Region {
		case De
	}
}
