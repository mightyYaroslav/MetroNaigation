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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

	var fromItem: MKMapItem!
	var toItem: MKMapItem!
	
	@IBOutlet weak var mapView: MKMapView!
	
	var locationManager = CLLocationManager()
	var userLocation: CLLocation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureLocationManager()
		addAnnotations()
	}
	
	func configureLocationManager() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestLocation()
	}
	
	func addAnnotations() {
		for item in [fromItem, toItem] {
			let annotation = MKPointAnnotation()
			annotation.title = item?.name
			annotation.coordinate = (item?.placemark.coordinate)!
			mapView.addAnnotation(annotation)
		}
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
				self.showRoute(response!)
			}
		})
	}
	
	func showRoute(_ response: MKDirectionsResponse) {
		for route in response.routes {
			mapView.add(route.polyline,
                level: MKOverlayLevel.aboveRoads)
		}
		
		let region =
			MKCoordinateRegionMakeWithDistance(fromItem.placemark.coordinate, 2000, 2000)
		
		mapView.setRegion(region, animated: true)
	}
	
	func mapView(_ mapView: MKMapView, rendererFor
		overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay: overlay)
		
		renderer.strokeColor = UIColor.blue
		renderer.lineWidth = 5.0
		return renderer
	}
//	
//	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//			let identifier = "pin"
//			var view: MKPinAnnotationView
//			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//				as? MKPinAnnotationView {
//				dequeuedView.annotation = annotation
//				view = dequeuedView
//			} else {
//				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//				view.canShowCallout = true
//				view.calloutOffset = CGPoint(x: -5, y: 5)
//				view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//			}
//			return view
//	}

}

