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
    
    var tabbarAction : ((_ index:Int) -> ())?
    
    enum DUTabbar {
        case Tab_1
        case Tab_2
        case Tab_3
        case Tab_4
        case Tab_Main
    }
    
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
        addCallBack()
    }
    
    func setAnimation(animationType:AnimationTypes){
        item1.setAnimationType(animationType: animationType)
        item2.setAnimationType(animationType: animationType)
        item3.setAnimationType(animationType: animationType)
        item4.setAnimationType(animationType: animationType)
        mainItem.setAnimationType(animationType: animationType)
    }
    
    func setSelectPageIndex(index:Int) {
        switch index {
        case 0:
            self.item1.startAnimation(isSelected: true)
            self.item2.startAnimation(isSelected: false)
            self.item3.startAnimation(isSelected: false)
            self.item4.startAnimation(isSelected: false)
            self.mainItem.startAnimation(isSelected: false)
            break
        case 1:
            self.item1.startAnimation(isSelected: false)
            self.item2.startAnimation(isSelected: true)
            self.item3.startAnimation(isSelected: false)
            self.item4.startAnimation(isSelected: false)
            self.mainItem.startAnimation(isSelected: false)
            break
        case 2:
            self.item1.startAnimation(isSelected: false)
            self.item2.startAnimation(isSelected: false)
            self.item3.startAnimation(isSelected: false)
            self.item4.startAnimation(isSelected: false)
            self.mainItem.startAnimation(isSelected: true)
            break
        case 3:
            self.item1.startAnimation(isSelected: false)
            self.item2.startAnimation(isSelected: false)
            self.item3.startAnimation(isSelected: true)
            self.item4.startAnimation(isSelected: false)
            self.mainItem.startAnimation(isSelected: false)
            break
        case 4:
            self.item1.startAnimation(isSelected: false)
            self.item2.startAnimation(isSelected: false)
            self.item3.startAnimation(isSelected: false)
            self.item4.startAnimation(isSelected: true)
            self.mainItem.startAnimation(isSelected: false)
            break
        default:
            break
        }
    }
    
    fileprivate func addCallBack(){
        item1.viewActionCallBack = {
            [weak self]  in
            guard let _self = self else{return}
            _self.setSelectPageIndex(index: 0)
            _self.tabbarAction?(0)
        }
        item2.viewActionCallBack = {
            [weak self]  in
            guard let _self = self else{return}
            _self.setSelectPageIndex(index: 1)
            _self.tabbarAction?(1)
        }
        item3.viewActionCallBack = {
            [weak self]  in
            guard let _self = self else{return}
            _self.setSelectPageIndex(index: 3)
            _self.tabbarAction?(3)
        }
        item4.viewActionCallBack = {
            [weak self]  in
            guard let _self = self else{return}
            _self.setSelectPageIndex(index: 4)
            _self.tabbarAction?(4)
        }
        
        mainItem.viewActionCallBack = {
            [weak self]  in
            guard let _self = self else{return}
            _self.setSelectPageIndex(index: 2)
            _self.tabbarAction?(2)
        }
    }
    
    // Loads a XIB file into a view and returns this view.
    fileprivate func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}


