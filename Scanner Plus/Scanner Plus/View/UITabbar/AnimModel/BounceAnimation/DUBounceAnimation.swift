//
//  DUBounceAnimation.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DUBounceAnimation: DUItemAnimation {

    override func selectAnimation(icon: UIImageView, text: UILabel) {
        
        super.selectAnimation(icon: icon, text: text)
        text.textColor = selectedTextColor
        let bounceAnimation = CAKeyframeAnimation(keyPath: AnimationKeys.Scale.rawValue)
        bounceAnimation.values = [1.0 ,1.4, 0.9, 1.15, 0.95, 1.02, 1.0]
        bounceAnimation.duration = TimeInterval(duration)
        bounceAnimation.calculationMode = kCAAnimationCubic
        
        icon.layer.add(bounceAnimation, forKey: nil)
        
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
