import Foundation
import CoreLocation


final class LocationManager: NSObject {
	static let shared = LocationManager()
	
	var deviceLocation: CLLocation?
	lazy private var manager: CLLocationManager = {
		var m = CLLocationManager()
		m.desiredAccuracy = kCLLocationAccuracyHundredMeters
		m.delegate = LocationManager.shared
		return m
	}()
	
	private override init() {}
	
	func findDeviceLocation() {
		guard CLLocationManager.locationServicesEnabled() else { return }
		
		let status = CLLocationManager.authorizationStatus()
		
		if status == .notDetermined {
			manager.requestWhenInUseAuthorization()
			return
		}
		
		if status == .authorizedWhenInUse {
			manager.requestLocation()
		}
	}
}
	
extension LocationManager: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager,
						 didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			manager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		if let newLocation = locations.last {
			deviceLocation = newLocation
			NotificationCenter.default.post(name: Notification.Name(notificationLocationUpdated),
											object: self)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error)
	}
}
