import UIKit
import MapKit


fileprivate let annotationViewID = "pin_view"


protocol MapViewProtocol: class {
	func updateMap(with pins: [MKPointAnnotation])
}


class MapViewController: UIViewController {
	@IBOutlet weak var mapView: MKMapView!
	private var presenter: MapPresenterProtocol!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter = MapPresenter(view: self)
		presenter.getPins()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		
	}
}

extension MapViewController: MapViewProtocol {
	func updateMap(with pins: [MKPointAnnotation]) {
		mapView.showAnnotations(pins, animated: true)
	}
}

extension MapViewController: MKMapViewDelegate {
	func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
		
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		var view = mapView.dequeueReusableAnnotationView(withIdentifier: annotationViewID) as? MKPinAnnotationView
		if view == nil {
			view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationViewID)
			view!.animatesDrop = true
			view!.canShowCallout = true
		}
		
		view!.annotation = annotation
		return view
	}
}

