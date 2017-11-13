import Foundation
import CoreLocation


func distanceString(to bar: Bar) -> String {
	guard let currentLocation = LocationManager.shared.deviceLocation else { return "" }
	
	let barLocation = CLLocation(latitude: bar.latitude, longitude: bar.longitude)
	let distance = Int(currentLocation.distance(from: barLocation))
	
	return "\(distance) m"
}
