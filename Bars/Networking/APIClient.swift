import Foundation


class APIClient {
	static func fetch<T>(_ resource: Resource<T>, completion: @escaping (T?) -> Void) {
		URLSession.shared.dataTask(with: resource.url) { data, response, error in
			if let data = data {
				completion(resource.parse(data))
			}
			else {
				completion(nil)
			}
		}.resume()
	}
}
