//
//  DUTabbarItemMain.swift
//  Scanner Plus
//
//  Created by Nguyen Manh Tuan on 12/11/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DUTabbarItemMain: DUBaseItem {
 
    @IBOutlet weak var circleView: UIView!
    
    override func setupView() {
        super.setupView()
        backgroundColor = UIColor.clear
        addTouchEvent()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleView.clipsToBounds = true
        circleView.layer.cornerRadius = self.bounds.size.height/2
    }
}
