import UIKit
import MapKit

class DemoTravelViewController: UIViewController, DemoController {
	weak var menuController: CariocaController?
    @IBOutlet weak var mapView: MKMapView!

	override var preferredStatusBarStyle: UIStatusBarStyle { return .default }

    override func viewDidLoad() {
        setupMap()
    }

    private func setupMap() {
        mapView.showsScale = false
        mapView.showsCompass = false
        mapView.showsTraffic = false
        mapView.mapType = .standard
        mapView.showsUserLocation = false
        mapView.showsPointsOfInterest = false
    }

    private func cleanMap() {
        mapView.mapType = .hybrid
        mapView.removeFromSuperview()
        mapView = nil
        self.menuController = nil
    }

	override func viewWillAppear(_ animated: Bool) {
		self.view.addCariocaGestureHelpers([.left, .right], width: 30.0)
	}

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        cleanMap()
    }
}
