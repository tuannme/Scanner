//
//  DUFrameAnimation.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DUFrameAnimation: DUItemAnimation {

    fileprivate var animationImages:[CGImage] = []
    
    func setAnimationImages(images:[UIImage]){
        for image in images{
            if let cgImage = image.cgImage{
                animationImages.append(cgImage)
            }
        }
    }
    
    override func selectAnimation(icon: UIImageView, text: UILabel) {
        super.selectAnimation(icon: icon, text: text)
        playFrameAnimation(icon, images:animationImages)
        text.textColor = selectedTextColor
    }
    
    override func deSelectAnination(icon: UIImageView, text: UILabel) {
        playFrameAnimation(icon, images:animationImages.reversed())
        text.textColor = defaultTextColor
    }
    
    @nonobjc func playFrameAnimation(_ icon : UIImageView, images : Array<CGImage>) {
        let frameAnimation = CAKeyframeAnimation(keyPath: AnimationKeys.KeyFrame.rawValue)
        frameAnimation.calculationMode = kCAAnimationDiscrete
        frameAnimation.duration = TimeInterval(duration)
        frameAnimation.values = images
        frameAnimation.repeatCount = 1
        frameAnimation.isRemovedOnCompletion = false
        frameAnimation.fillMode = kCAFillModeForwards
        icon.layer.add(frameAnimation, forKey: nil)
    }
    
}
