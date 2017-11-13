import UIKit


fileprivate let cellID = "cell_bar"

protocol ListViewProtocol: class {
	func updateBarList(with bars: [Bar]?)
	func open(url: URL)
	func showLoading()
	func hideLoading()
}


class ListViewController: UIViewController {
	private var presenter: ListPresenterProtocol!
	private var bars: [Bar] = []
	
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var loadingView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		presenter = ListPresenter(view: self)
		presenter.getBars()
		tableView.tableFooterView = UIView()
	}
}

extension ListViewController: ListViewProtocol {
	func updateBarList(with bars: [Bar]?) {
		if let bars = bars {
			self.bars = bars
			tableView.reloadSections([0], with: UITableViewRowAnimation.fade)
		}
	}
	
	func open(url: URL) {
		UIApplication.shared.open(url)
	}
	
	func showLoading() {
		tableView.isHidden = true
		loadingView.isHidden = false
	}
	
	func hideLoading() {
		tableView.isHidden = false
		loadingView.isHidden = true
	}
}

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return bars.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
		let bar = bars[indexPath.row]
		
		cell.textLabel?.text = bar.name
		cell.detailTextLabel?.text = distanceString(to: bar)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let bar = bars[indexPath.row]
		presenter.onBarSelected(bar)
	}
}
