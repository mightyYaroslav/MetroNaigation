//
//  Station.swift
//  MetroNavigation
//
//  Created by Yaroslav Bay on 08.05.17.
//  Copyright © 2017 Yaroslav Bay. All rights reserved.
//

import Foundation
import MapKit

class Station: NSObject, MKAnnotation {
	let title: String?
	let locationName: String?
	let discipline: String
	let coordinate: CLLocationCoordinate2D
	
	init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D) {
		self.title = title
		self.locationName = locationName
		self.discipline = discipline
		self.coordinate = coordinate
		
		super.init()
	}
	
	var subtitle: String? {
		return locationName
	}
	
	// annotation callout info button opens this mapItem in Maps app
//	func mapItem() -> MKMapItem {
//		let addressDictionary = [String(kABPersonAddressStreetKey): subtitle]
//		let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
//		
//		let mapItem = MKMapItem(placemark: placemark)
//		mapItem.name = title
//		
//		return mapItem
//	}
}
