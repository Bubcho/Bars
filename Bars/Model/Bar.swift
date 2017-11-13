import Foundation
import CoreLocation


struct Bar {
	let id: String
	let name: String
	let latitude: Double
	let longitude: Double
}

extension Bar: Decodable {
	enum BarKey: String, CodingKey {
		case id
		case name
		case geometry
		case location
		case lat
		case lng
	}
	
	init(from decoder: Decoder) throws {
		let root = try decoder.container(keyedBy: BarKey.self)
		let geometry = try root.nestedContainer(keyedBy: BarKey.self, forKey: .geometry)
		let location = try geometry.nestedContainer(keyedBy: BarKey.self, forKey: .location)
		
		let id = try root.decode(String.self, forKey: .id)
		let name = try root.decode(String.self, forKey: .name)
		let latitude = try location.decode(Double.self, forKey: .lat)
		let longitude = try location.decode(Double.self, forKey: .lng)

		self.init(id: id, name: name, latitude: latitude, longitude: longitude)
	}
}

extension Bar {
	static func barsNearby(to location: CLLocation) -> Resource<[Bar]> {
		let lat = location.coordinate.latitude
		let lng = location.coordinate.longitude
		let url = URL(string:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lng)&radius=1000&type=bar&key=\(googlePlacesAPIKey)")!
		return Resource<[Bar]>(url: url) { data in
			do {
				let service = try JSONDecoder().decode(NearbyService.self, from: data)
				return service.results
			}
			catch {
				print(error)
			}
			return nil
		}
	}
}
