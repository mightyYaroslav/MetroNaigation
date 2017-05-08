//
//  MarginedLabel.swift
//  MetroNavigation
//
//  Created by Yaroslav Bay on 08.05.17.
//  Copyright © 2017 Yaroslav Bay. All rights reserved.
//

import UIKit

class MarginedLabel: UILabel {

    override func draw(_ rect: CGRect) {
		let insets = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
		super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }

}
