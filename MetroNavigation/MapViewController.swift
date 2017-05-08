//
//  ViewController.swift
//  MetroNavigation
//
//  Created by Yaroslav Bay on 08.05.17.
//  Copyright © 2017 Yaroslav Bay. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import NVActivityIndicatorView

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

	var fromItem: MKMapItem!
	var toItem: MKMapItem!
	
	@IBOutlet weak var mapView: MKMapView!
	var animationIndicator: NVActivityIndicatorView!
	
	var locationManager = CLLocationManager()
	var userLocation: CLLocation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		mapView.isHidden = true
		configureLocationManager()
		configureAnimation()
		startAnimation()
		addAnnotations()
		setRegion()
	}
	
	func configureLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestLocation()
	}
	
	func configureAnimation() {
		let indicatorWidth: CGFloat = 60
		let indicatorHeight: CGFloat = 60
		
		let indicatorX = (UIScreen.main.bounds.width - indicatorWidth) / 2
		let indicatorY = (UIScreen.main.bounds.height - (navigationController?.navigationBar.bounds.height)! - indicatorHeight) / 2
		
		animationIndicator = NVActivityIndicatorView(frame: CGRect(x: indicatorX, y:indicatorY, width: indicatorWidth, height: indicatorHeight), type: .ballRotate, color: UIColor(hex: 0x205FAB))
	}
	
	func startAnimation() {
		view.addSubview(animationIndicator)
		animationIndicator.isHidden = false
		animationIndicator.startAnimating()
	}
	
	func stopAnimation() {
		animationIndicator.stopAnimating()
		animationIndicator.isHidden = true
		animationIndicator.removeFromSuperview()
	}
	
	func addAnnotations() {
		for item in [fromItem, toItem] {
			let annotation = MKPointAnnotation()
			annotation.title = item?.name
			if item == fromItem {
				annotation.subtitle = "Source"
			} else {
				annotation.subtitle = "Destination"
			}
			annotation.coordinate = (item?.placemark.coordinate)!
			mapView.addAnnotation(annotation)
		}
	}
	
	func setRegion() {
		let region = MKCoordinateRegionMakeWithDistance(fromItem.placemark.coordinate, 2000, 2000)
		mapView.setRegion(region, animated: true)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		userLocation = locations[0]
		direct()
	}
	
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
	
	func direct() {
		let request = MKDirectionsRequest()
		request.source = fromItem
		request.destination = toItem
		request.requestsAlternateRoutes = false
		
		let directions = MKDirections(request: request)
		
		directions.calculate(completionHandler: {(response, error) in
			if error != nil {
				print("Error getting directions")
			} else {
				self.mapView.isHidden = false
				self.stopAnimation()
				self.showRoute(response!)
			}
		})
	}
	
	func showRoute(_ response: MKDirectionsResponse) {
		for route in response.routes {
			mapView.add(route.polyline,
                level: MKOverlayLevel.aboveRoads)
		}
	}
	
	func mapView(_ mapView: MKMapView, rendererFor
		overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay: overlay)
		
		renderer.strokeColor = UIColor.blue
		renderer.lineWidth = 5.0
		return renderer
	}

}

