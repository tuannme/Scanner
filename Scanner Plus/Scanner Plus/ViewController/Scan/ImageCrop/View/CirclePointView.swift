//
//  CirclePointView.swift
//  Scanner Plus
//
//  Created by Nguyen Manh Tuan on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class CirclePointView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        layer.cornerRadius = bounds.width/2
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        clipsToBounds = true
    }
    


}
