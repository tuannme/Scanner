//
//  DrawView.swift
//  Scanner Plus
//
//  Created by Nguyen Manh Tuan on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DrawView: UIView {

    enum Side:String{
        case Left
        case Right
        case InLine
    }
    
    var circleViews : [CirclePointView] = []
    let size:CGFloat = 30
    
    private var moveView:CirclePointView?
    private let bezierPath:UIBezierPath = UIBezierPath()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView(){
        backgroundColor = UIColor.clear
    }

    func addPoints(points:[CGPoint]){
        let circleSize = CGSize(width: size, height: size)
        for point in points{
            let circleFrame = CGRect(origin: point, size: circleSize)
            let circleView = CirclePointView(frame: circleFrame)
            circleViews.append(circleView)
            addSubview(circleView)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for circleView in circleViews{
            guard let touch = touches.first?.location(in: circleView) else{return}
            if touch.x > -size/2 && touch.y > -size/2 && touch.x <= size && touch.y <= size{
                moveView = circleView
                break
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let moveView = moveView{
            guard let touch = touches.first?.location(in: self) else{return}
            
            switch moveView{
            case circleViews[0]:
                let side1 = checkPointSideOfLine(checkPoint: circleViews[0].center,
                                     firstPoint: circleViews[1].center,
                                     endPoint: circleViews[2].center)
                
                let side2 = checkPointSideOfLine(checkPoint: circleViews[0].center,
                                     firstPoint: circleViews[2].center,
                                     endPoint: circleViews[3].center)
                
                print("side1 \(side1.rawValue) __ side2 \(side2.rawValue)")
                
                break
            case circleViews[1]:
                checkPointSideOfLine(checkPoint: circleViews[1].center,
                                     firstPoint: circleViews[2].center,
                                     endPoint: circleViews[3].center)
                
                checkPointSideOfLine(checkPoint: circleViews[1].center,
                                     firstPoint: circleViews[0].center,
                                     endPoint: circleViews[3].center)
                
                break
            case circleViews[2]:
                checkPointSideOfLine(checkPoint: circleViews[2].center,
                                     firstPoint: circleViews[3].center,
                                     endPoint: circleViews[0].center)
                
                checkPointSideOfLine(checkPoint: circleViews[2].center,
                                     firstPoint: circleViews[0].center,
                                     endPoint: circleViews[1].center)
                
                break
            case circleViews[3]:
                checkPointSideOfLine(checkPoint: circleViews[3].center,
                                     firstPoint: circleViews[0].center,
                                     endPoint: circleViews[1].center)
                
                checkPointSideOfLine(checkPoint: circleViews[3].center,
                                     firstPoint: circleViews[1].center,
                                     endPoint: circleViews[2].center)
                break
            default:
                break
            }
            
            moveView.center = touch
            setNeedsDisplay()
        }
    }
    
    fileprivate func checkPointSideOfLine(checkPoint:CGPoint,firstPoint:CGPoint,endPoint:CGPoint) -> Side{
        let d = (checkPoint.x - firstPoint.x)*(endPoint.y - firstPoint.y) - (checkPoint.y - firstPoint.y)*(endPoint.x - endPoint.y)
        if d == 0 {
            //print("InLine")
            return .InLine
        }
        if d > 0{
            //print("Right")
            return .Left
        }
        //print("Left")
        return .Right
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveView = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveView = nil
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        bezierPath.removeAllPoints()
        var firstPoint = true
        for circle in circleViews{
            let point = circle.center
            if firstPoint{
                bezierPath.move(to: point)
                firstPoint = false
            }else{
                bezierPath.addLine(to: point)
            }
        }
        bezierPath.close()
        
        UIColor.clear.setFill()
        UIColor.white.setStroke()
        bezierPath.stroke()
        bezierPath.fill()
        
        borderBackgroundView()
        
    }
    
    fileprivate func borderBackgroundView(){
        
        let topLeft = CGPoint(x: 0, y: 0)
        let topRight = CGPoint(x: frame.width, y: 0)
        let bottomLeft = CGPoint(x: 0, y: frame.height)
        let bottomRight = CGPoint(x: frame.width, y: frame.height)
        
        let path1 = UIBezierPath()
        path1.move(to: topLeft)
        path1.addLine(to: circleViews[0].center)
        path1.addLine(to: circleViews[1].center)
        path1.addLine(to: topRight)
        path1.close()
        
        let path2 = UIBezierPath()
        path2.move(to: topRight)
        path2.addLine(to: circleViews[1].center)
        path2.addLine(to: circleViews[2].center)
        path2.addLine(to: bottomRight)
        path2.close()
        
        let path3 = UIBezierPath()
        path3.move(to: bottomRight)
        path3.addLine(to: circleViews[2].center)
        path3.addLine(to: circleViews[3].center)
        path3.addLine(to: bottomLeft)
        path3.close()
        
        let path4 = UIBezierPath()
        path4.move(to: bottomLeft)
        path4.addLine(to: circleViews[3].center)
        path4.addLine(to: circleViews[0].center)
        path4.addLine(to: topLeft)
        path4.close()
        
        UIColor.black.withAlphaComponent(0.5).setFill()
        UIColor.clear.setStroke()
        path1.stroke()
        path1.fill()
        
        path2.stroke()
        path2.fill()
        
        path3.stroke()
        path3.fill()
        
        path4.stroke()
        path4.fill()
        
    }
    
}
