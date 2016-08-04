//
//  Constants.swift
//  socialApp
//
//  Created by Jonathan Bohrer on 8/3/16.
//  Copyright © 2016 Jonathan Bohrer. All rights reserved.
//

import UIKit

let SHADOW_COLOR: CGFloat = 120.0 / 255.0

let KEY_UID = "uid"

func shadow(object: AnyObject) {
    object.layer.shadowColor = UIColor(red: SHADOW_COLOR, green: SHADOW_COLOR, blue: SHADOW_COLOR, alpha: 0.6).CGColor
    object.layer.shadowOpacity = 0.8
    object.layer.shadowRadius = 5.0
    object.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
}