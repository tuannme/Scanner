//
//  DURotationAnimation.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DURotationAnimation: DUItemAnimation {

    enum RotationDirection {
        case left
        case right
    }
    
    var direction:RotationDirection = .left
    
    override func selectAnimation(icon: UIImageView, text: UILabel) {
        
        super.selectAnimation(icon: icon, text: text)
        text.textColor = selectedTextColor
        
        let rotateAnimation = CABasicAnimation(keyPath: AnimationKeys.Rotation.rawValue)
        rotateAnimation.fromValue = 0.0
        
        var toValue = CGFloat.pi * 2
        if direction == .left {
            toValue = toValue * -1.0
        }
        
        rotateAnimation.toValue = toValue
        rotateAnimation.duration = TimeInterval(duration)
        
        icon.layer.add(rotateAnimation, forKey: nil)
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = selectedIconColor
        }
    }
    

    override func deSelectAnination(icon: UIImageView, text: UILabel) {
        
        text.textColor = defaultTextColor
        
        if let iconImage = icon.image {
            let renderMode = defaultIconColor.cgColor.alpha == 0 ? UIImageRenderingMode.alwaysOriginal :
                UIImageRenderingMode.alwaysTemplate
            let renderImage = iconImage.withRenderingMode(renderMode)
            icon.image = renderImage
            icon.tintColor = defaultIconColor
        }
    }
    
}
