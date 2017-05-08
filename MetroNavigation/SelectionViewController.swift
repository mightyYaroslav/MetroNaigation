//
//  SelectionViewController.swift
//  MetroNavigation
//
//  Created by Yaroslav Bay on 08.05.17.
//  Copyright © 2017 Yaroslav Bay. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CLLocationManagerDelegate {
	
	var fromIndex = 0
	var toIndex = 0
	
	var stations = [MKMapItem]()
	let searchText = "subway station"
	
	var locationManager = CLLocationManager()
	var userLocation: CLLocation?
	
	@IBOutlet weak var fromLabel: UILabel!
	@IBOutlet weak var toLabel: UILabel!
	@IBOutlet weak var stationPickerView: UIPickerView!
	
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
			request.region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 10000, 10000)
			
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
					self.stationPickerView.reloadAllComponents()
				}
			})
		}
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 2
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return stations.count
	}
	
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return stations.isEmpty ? nil: stations[row].name
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		if !stations.isEmpty {
			if component == 0 {
				fromIndex = row
				fromLabel.text = stations[row].name
			} else if component == 1 {
				toLabel.text = stations[row].name
				toIndex = row
			}
		}
	}
	
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "selectionToMap" {
			let vc = segue.destination as! MapViewController
			vc.fromItem = stations[fromIndex]
			vc.toItem = stations[toIndex]
		}
    }
	

}
