//
//  DUFumeAnimation.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DUFumeAnimation: DUItemAnimation {

    override func selectAnimation(icon: UIImageView, text: UILabel) {
        super.selectAnimation(icon: icon, text: text)
        playMoveIconAnimation(icon, values:[icon.center.y as AnyObject, (icon.center.y + 4.0) as AnyObject])
        playLabelAnimation(text)
        text.textColor = selectedTextColor
        
        if let iconImage = icon.image {
            let renderImage = iconImage.withRenderingMode(.alwaysTemplate)
            icon.image = renderImage
            icon.tintColor = selectedIconColor
        }
    }
    
    override func deSelectAnination(icon: UIImageView, text: UILabel) {
        playMoveIconAnimation(icon, values:[(icon.center.y + 4.0) as AnyObject, icon.center.y as AnyObject])
        playDeselectLabelAnimation(text)
        text.textColor = defaultTextColor
        
        if let iconImage = icon.image {
            let renderMode = defaultIconColor.cgColor.alpha == 0 ? UIImageRenderingMode.alwaysOriginal :
                UIImageRenderingMode.alwaysTemplate
            let renderImage = iconImage.withRenderingMode(renderMode)
            icon.image = renderImage
            icon.tintColor = defaultIconColor
        }
    }
    
    
    func playMoveIconAnimation(_ icon : UIImageView, values: [AnyObject]) {
        
        let yPositionAnimation = createAnimation(AnimationKeys.PositionY.rawValue, values:values, duration:duration / 2)
        
        icon.layer.add(yPositionAnimation, forKey: nil)
    }
    
    // MARK: select animation
    
    func playLabelAnimation(_ textLabel: UILabel) {
        
        let yPositionAnimation = createAnimation(AnimationKeys.PositionY.rawValue, values:[textLabel.center.y as AnyObject, (textLabel.center.y - 60.0) as AnyObject], duration:duration)
        yPositionAnimation.fillMode = kCAFillModeRemoved
        yPositionAnimation.isRemovedOnCompletion = true
        textLabel.layer.add(yPositionAnimation, forKey: nil)
        
        let scaleAnimation = createAnimation(AnimationKeys.Scale.rawValue, values:[1.0 as AnyObject ,2.0 as AnyObject], duration:duration)
        scaleAnimation.fillMode = kCAFillModeRemoved
        scaleAnimation.isRemovedOnCompletion = true
        textLabel.layer.add(scaleAnimation, forKey: nil)
        
        let opacityAnimation = createAnimation(AnimationKeys.Opacity.rawValue, values:[1.0 as AnyObject ,0.0 as AnyObject], duration:duration)
        textLabel.layer.add(opacityAnimation, forKey: nil)
    }
    
    func createAnimation(_ keyPath: String, values: [AnyObject], duration: CGFloat)->CAKeyframeAnimation {
        
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.values = values
        animation.duration = TimeInterval(duration)
        animation.calculationMode = kCAAnimationCubic
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        return animation
    }
    
    // MARK: deselect animation
    
    func playDeselectLabelAnimation(_ textLabel: UILabel) {
        
        let yPositionAnimation = createAnimation(AnimationKeys.PositionY.rawValue, values:[(textLabel.center.y + 15) as AnyObject, textLabel.center.y as AnyObject], duration:duration)
        textLabel.layer.add(yPositionAnimation, forKey: nil)
        
        let opacityAnimation = createAnimation(AnimationKeys.Opacity.rawValue, values:[0 as AnyObject, 1 as AnyObject], duration:duration)
        textLabel.layer.add(opacityAnimation, forKey: nil)
    }
}
