//
//  roundRectBtn.swift
//  socialApp
//
//  Created by Jonathan Bohrer on 8/3/16.
//  Copyright © 2016 Jonathan Bohrer. All rights reserved.
//

import UIKit

class roundRectBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadow(self)
        
        layer.cornerRadius = 3.0
        // clipsToBounds = true
    }

}
