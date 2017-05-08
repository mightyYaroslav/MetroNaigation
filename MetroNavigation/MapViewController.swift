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
	let regionRadius: CLLocationDistance = 1000
	let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
	
	var locationManager = CLLocationManager()
	var userLocation: CLLocation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestLocation()
	}
	
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
		                                                          regionRadius * 2.0, regionRadius * 2.0)
		mapView.setRegion(coordinateRegion, animated: true)
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
		request.transportType = .transit
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
			
			for step in route.steps {
				print(step.instructions)
			}
		}
		
		let region =
			MKCoordinateRegionMakeWithDistance(userLocation!.coordinate, 2000, 2000)
		
		mapView.setRegion(region, animated: true)
	}
	
	func mapView(_ mapView: MKMapView, rendererFor
		overlay: MKOverlay) -> MKOverlayRenderer {
		let renderer = MKPolylineRenderer(overlay: overlay)
		
		renderer.strokeColor = UIColor.blue
		renderer.lineWidth = 5.0
		return renderer
	}
	
}

