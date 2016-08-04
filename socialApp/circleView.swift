//
//  circleView.swift
//  socialApp
//
//  Created by Jonathan Bohrer on 8/3/16.
//  Copyright © 2016 Jonathan Bohrer. All rights reserved.
//

import UIKit

class circleView: UIImageView {

    override func awakeFromNib() {
        super.awakeFromNib()
        shadow(self)
        layer.cornerRadius = layer.bounds.width / 2
    }

}
