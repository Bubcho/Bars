import Foundation
import MapKit


protocol MapPresenterProtocol {
	init(view: MapViewProtocol)
	func getPins()
}

class MapPresenter: MapPresenterProtocol {
	unowned private var view: MapViewProtocol
	
	required init(view: MapViewProtocol) {
		self.view = view
		NotificationCenter.default.addObserver(self,
											   selector: #selector(getPins),
											   name: NSNotification.Name(notificationNewDataAvailable),
											   object: Repository.shared)
	}
	
	@objc func getPins() {
		if let bars = Repository.shared.data {
			let pins = bars.map { (bar) -> MKPointAnnotation in
				let pin = MKPointAnnotation()
				pin.coordinate = CLLocationCoordinate2D(latitude: bar.latitude, longitude: bar.longitude)
				pin.title = bar.name
				pin.subtitle = distanceString(to: bar)
				return pin
			}
			view.updateMap(with: pins)
		}
	}
}
