//
//  DUBaseItem.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

protocol DUBaseItemProtocol {
    func startAnimation(isSelected:Bool)
}

class DUBaseItem: DUBaseCustomView,DUBaseItemProtocol{
    
    @IBOutlet weak var iconImv: UIImageView!
    @IBOutlet weak var textLb: UILabel!
    
    var viewActionCallBack : (() -> ())?
    var isSelected :Bool = false
    var animation:DUItemAnimation?
    
    func addTouchEvent(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didSelectItem))
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
    }
    
    @objc fileprivate func didSelectItem(){
        if !isSelected{
            viewActionCallBack?()
        }else{
          startAnimation(isSelected: true)
        }
    }
    
    func startAnimation(isSelected: Bool) {
        self.isSelected = isSelected
        if isSelected{
            animation?.selectAnimation(icon: iconImv, text: textLb)
        }else{
            animation?.deSelectAnination(icon: iconImv, text: textLb)
        }
    }
    
    func setAnimationType(animationType:AnimationTypes){
        switch animationType {
        case .Bounce:
            animation = DUBounceAnimation()
            break
        case .Fume:
            animation = DUFumeAnimation()
            break
        case .Rotation:
            animation = DURotationAnimation()
            break
        case .Transition:
            animation = DUTransitionAnimation()
            break
        default:
            break
        }
    }
}
