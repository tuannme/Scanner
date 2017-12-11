//
//  DUTabbar.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/11/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DUTabbarView: UIView {

    @IBOutlet weak var item1: DUTabbarItem!
    @IBOutlet weak var item2: DUTabbarItem!
    @IBOutlet weak var item3: DUTabbarItem!
    @IBOutlet weak var item4: DUTabbarItem!
    @IBOutlet weak var mainItem: DUTabbarItemMain!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    fileprivate func setupView() {
        let view = viewFromNibForClass()
        view.frame = bounds
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    fileprivate func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}


