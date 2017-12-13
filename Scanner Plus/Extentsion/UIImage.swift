//
//  UIImage.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/13/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

extension UIImage{
    
    func cropImage(image:UIImage,path:UIBezierPath) -> UIImage?{
        let rect = path.cgPath.boundingBox
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false,image.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.translateBy(x: -rect.origin.x, y: -rect.origin.y)
        ctx?.addPath(path.cgPath)
        ctx?.clip()
        
        image.draw(in: CGRect(origin: .zero, size: image.size))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    
}
