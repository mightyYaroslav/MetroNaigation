//
//  ViewController.swift
//  MetroNavigation
//
//  Created by Yaroslav Bay on 08.05.17.
//  Copyright © 2017 Yaroslav Bay. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

	@IBOutlet weak var mapView: MKMapView!
	let regionRadius: CLLocationDistance = 1000
	let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
	
	override func viewDidLoad() {
		super.viewDidLoad()

		centerMapOnLocation(location: initialLocation)
		addAnnotationToMap()
	}
	
	func centerMapOnLocation(location: CLLocation) {
		let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
		                                                          regionRadius * 2.0, regionRadius * 2.0)
		mapView.setRegion(coordinateRegion, animated: true)
		
	}
	
	func addAnnotationToMap() {
		let artwork = Artwork(title: "King David Kalakaua",
		                      locationName: "Waikiki Gateway Park",
		                      discipline: "Sculpture",
		                      coordinate: CLLocationCoordinate2D(latitude: 21.283921, longitude: -157.831661))
		
		mapView.addAnnotation(artwork)
	}
	
	func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!,
	             calloutAccessoryControlTapped control: UIControl!) {
		  let location = view.annotation as! Artwork
		  let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
		  location.mapItem().openInMaps(launchOptions: launchOptions)
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		if let annotation = annotation as? Artwork {
			let identifier = "pin"
			var view: MKPinAnnotationView
			if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
				as? MKPinAnnotationView {
				dequeuedView.annotation = annotation
				view = dequeuedView
			} else {
				view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
				view.canShowCallout = true
				view.calloutOffset = CGPoint(x: -5, y: 5)
				view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
			}
			return view
		}
		return nil
	}
	
	


}

