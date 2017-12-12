//
//  DUTransitionAnimation.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DUTransitionAnimation: DUItemAnimation {

    var transitionOptions: UIViewAnimationOptions  = UIViewAnimationOptions.transitionFlipFromTop

    override func selectAnimation(icon: UIImageView, text: UILabel) {
    
        super.selectAnimation(icon: icon, text: text)
        text.textColor = selectedTextColor
        if let iconImage = icon.image{
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = selectedIconColor
        }
        
        UIView.transition(with: icon, duration: TimeInterval(duration), options: transitionOptions, animations: {
        }, completion: { _ in
        })
        
       
    }
    
    override func deSelectAnination(icon: UIImageView, text: UILabel) {
        if let iconImage = icon.image {
            let renderMode = defaultIconColor.cgColor.alpha == 0 ? UIImageRenderingMode.alwaysOriginal :
                UIImageRenderingMode.alwaysTemplate
            let renderImage = iconImage.withRenderingMode(renderMode)
            icon.image = renderImage
            icon.tintColor = defaultIconColor
        }
        text.textColor = defaultTextColor
    }
    
}
