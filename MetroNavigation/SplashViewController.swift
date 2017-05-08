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
import NVActivityIndicatorView

class SplashViewController: UIViewController, CLLocationManagerDelegate {

	
	@IBOutlet weak var loadingView: UIView!
	var animationIndicator: NVActivityIndicatorView!
	
	var fromIndex = 0
	var toIndex = 0
	
	var stations = [MKMapItem]()
	let searchText = "subway station"
	
	var locationManager = CLLocationManager()
	var userLocation: CLLocation?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureAnimation()
		configureLocationManager()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		startAnimation()
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		stopAnimation()
	}
	
	func configureAnimation() {
		let indicatorWidth: CGFloat = 60
		let indicatorHeight: CGFloat = 60
		
		let indicatorX = (UIScreen.main.bounds.width - indicatorWidth) / 2
		let indicatorY = (loadingView.bounds.height - indicatorHeight) / 2
		
		animationIndicator = NVActivityIndicatorView(frame: CGRect(x: indicatorX, y:indicatorY, width: indicatorWidth, height: indicatorHeight), type: .ballRotate, color: UIColor(hex: 0x205FAB))
	}

	func startAnimation() {
		loadingView.addSubview(animationIndicator)
		loadingView.isHidden = true
		animationIndicator.isHidden = false
		view.addSubview(loadingView)
		
		animationIndicator.startAnimating()
		loadingView.isHidden = false
	}
	
	func stopAnimation() {
		animationIndicator.stopAnimating()
		loadingView.isHidden = true
		loadingView.removeFromSuperview()
	}
	
	func configureLocationManager() {
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
					
				} else if response!.mapItems.count != 0 {
					
					for item in response!.mapItems {
						self.stations.append(item as MKMapItem)
					}
					
					self.performSegue(withIdentifier: "splashToSelection", sender: self)
					search.cancel()
				}
			})
		}
	}
	
	
	// MARK: - Navigation
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "splashToSelection" {
			let nvc = segue.destination as! UINavigationController
			let vc = nvc.viewControllers[0] as! SelectionViewController
			vc.stations = stations
		}
	}

}
