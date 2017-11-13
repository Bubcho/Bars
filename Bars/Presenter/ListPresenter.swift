import Foundation


protocol ListPresenterProtocol {
	init(view: ListViewProtocol)
	func getBars()
	func onBarSelected(_ bar: Bar)
}


class ListPresenter: ListPresenterProtocol {
	unowned private var view: ListViewProtocol
	
	required init(view: ListViewProtocol) {
		self.view = view
		NotificationCenter.default.addObserver(self,
											   selector: #selector(getBars),
											   name: NSNotification.Name(notificationNewDataAvailable),
											   object: Repository.shared)
	}
	
	@objc func getBars() {
		DispatchQueue.main.async {
			// Call the view on the main thread because this closure is being called from a worker thread
			self.view.showLoading()
			
			if let bars = Repository.shared.data {
				self.view.updateBarList(with: bars)
				self.view.hideLoading()
			}
		}
	}
	

	
	func googleMapsURL(for bar: Bar) -> URL {
		let lat = bar.latitude
		let lng = bar.longitude
		let encodedName = bar.name.addingPercentEncodingForQueryParameter()!
		
		return URL(string: "https://maps.google.com/maps?center=\(lat),\(lng)&q=\(encodedName)&zoom=14")!
	}
	
	func onBarSelected(_ bar: Bar) {
		view.open(url: googleMapsURL(for: bar))
	}
}
