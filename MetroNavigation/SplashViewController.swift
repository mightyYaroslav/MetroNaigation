//
//  SplashViewController.swift
//  MetroNavigation
//
//  Created by Yaroslav Bay on 08.05.17.
//  Copyright © 2017 Yaroslav Bay. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SplashViewController: UIViewController, CLLocationManagerDelegate {

	var fromIndex = 0
	var toIndex = 0
	
	var stations = [MKMapItem]()
	let searchText = "subway station"
	
	var locationManager = CLLocationManager()
	var userLocation: CLLocation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestLocation()
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		userLocation = locations[0]
		stations.removeAll()
		search()
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print(error.localizedDescription)
	}
	
	func search() {
		if let userLocation = userLocation {
			
			let request = MKLocalSearchRequest()
			
			request.naturalLanguageQuery = searchText
			request.region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 100000, 100000)
			
			let search = MKLocalSearch(request: request)
			
			search.start(completionHandler: {(response, error) in
				
				if error != nil {
					print("Error occured in search: \(error!.localizedDescription)")
				} else if response!.mapItems.count == 0 {
					print("No matches found")
				} else {
					print("Matches found")
					
					for item in response!.mapItems {
						self.stations.append(item as MKMapItem)
					}
					self.performSegue(withIdentifier: "splashToSelection", sender: self)
				}
			})
		}
	}
	
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "splashToSelection" {
			let vc = segue.destination as! SelectionViewController
			vc.stations = stations
		}
	}

}
