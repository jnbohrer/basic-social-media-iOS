//
//  roundBtn.swift
//  socialApp
//
//  Created by Jonathan Bohrer on 8/3/16.
//  Copyright © 2016 Jonathan Bohrer. All rights reserved.
//

import UIKit

class roundBtn: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadow(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = self.frame.width / 2
        //clipsToBounds = true
    }

}
