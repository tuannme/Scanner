//
//  DUItemAnimation.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

/**
 This is animation interface class
 */
protocol DUItemAnimationProtocol {
    
    func selectAnimation(icon : UIImageView, text : UILabel)
    func deSelectAnination(icon:UIImageView,text:UILabel)
    
}

enum AnimationTypes {
    case Fume
    case Bounce
    case Transition
    case Rotation
    case Frame
}

class DUItemAnimation: NSObject,DUItemAnimationProtocol {
    
    var defaultIconColor = UIColor.gray
    var defaultTextColor = UIColor.gray
    
    var selectedIconColor = UIColor.orange
    var selectedTextColor = UIColor.orange
    
    var duration : CGFloat = 0.5
    
    enum AnimationKeys:String {
        case Scale     = "transform.scale"
        case Rotation  = "transform.rotation"
        case KeyFrame  = "contents"
        case PositionY = "position.y"
        case Opacity   = "opacity"
    }
    
    func selectAnimation(icon: UIImageView, text: UILabel) {
        if let parentView = icon.superview{
            playRoundAnimation(parentView: parentView)
        }
    }
    
    func deSelectAnination(icon: UIImageView, text: UILabel) {
        //do nothing
    }
    
    func playRoundAnimation(parentView:UIView)  {
        
        let width:CGFloat = 10
        let circleView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        circleView.layer.cornerRadius = width/2
        circleView.clipsToBounds = true
        circleView.center = CGPoint(x: parentView.bounds.width/2, y: parentView.bounds.height/2)
        circleView.backgroundColor = selectedTextColor
        parentView.addSubview(circleView)
        
        UIView.animate(withDuration: 0.3, animations: {
            circleView.transform = CGAffineTransform(scaleX: 7, y: 7)
            circleView.backgroundColor = self.selectedTextColor.withAlphaComponent(0.2)
        }) { (done) in
            circleView.removeFromSuperview()
        }
       
    }
}
