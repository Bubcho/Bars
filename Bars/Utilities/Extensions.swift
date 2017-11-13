import Foundation


extension String {
	public func addingPercentEncodingForQueryParameter() -> String? {
		let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
		let subDelimitersToEncode = "!$&'()*+,;="
		
		var allowedCharacterSet = CharacterSet.urlQueryAllowed
		allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
		
		return addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
	}
}
