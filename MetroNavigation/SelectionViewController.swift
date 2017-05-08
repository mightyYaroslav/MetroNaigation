//
//  SelectionViewController.swift
//  MetroNavigation
//
//  Created by Yaroslav Bay on 08.05.17.
//  Copyright © 2017 Yaroslav Bay. All rights reserved.
//

import UIKit
import MapKit

class SelectionViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
	
	var fromIndex = 0
	var toIndex = 0
	
	var stations: [MKMapItem]!
	
	@IBOutlet weak var fromLabel: UILabel!
	@IBOutlet weak var toLabel: UILabel!
	@IBOutlet weak var stationPickerView: UIPickerView!
	@IBOutlet weak var goButton: UIButton!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		[fromLabel, toLabel].forEach(beautify)
		beautify(button: goButton)
		
		fromLabel.text = "From: " + stations[0].name!
		toLabel.text = "To: " + stations[0].name!
    }
	
	func beautify(label: UILabel) {
		label.layer.borderWidth = 2.0
		label.layer.borderColor = UIColor.lightGray.cgColor
		label.layer.cornerRadius = 10.0
	}
	
	func beautify(button: UIButton) {
		button.layer.borderWidth = 2.0
		button.layer.borderColor = UIColor.blue.cgColor
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
				fromLabel.text = "From: " + stations[row].name!
			} else if component == 1 {
				toLabel.text = "To: " + stations[row].name!
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
