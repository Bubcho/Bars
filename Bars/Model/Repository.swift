import Foundation


final class Repository {
	static let shared = Repository()
	private(set) var data: [Bar]? {
		didSet {
			// Notify presenters about new data
			NotificationCenter.default.post(name: Notification.Name(notificationNewDataAvailable),
											object: Repository.shared)
		}
	}
	
	private init() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(fetchData),
											   name: NSNotification.Name(notificationLocationUpdated),
											   object: LocationManager.shared)
	}
	
	@objc func fetchData() {
		if let currentLocation = LocationManager.shared.deviceLocation {
			APIClient.fetch(Bar.barsNearby(to: currentLocation)) { [unowned self] bars in
				self.data = bars
			}
		}
	}
}
