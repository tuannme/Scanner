//
//  DrawView.swift
//  Scanner Plus
//
//  Created by Nguyen Manh Tuan on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DrawView: UIView {

    var circleViews : [CirclePointView] = []
    let bezierPath:UIBezierPath = UIBezierPath()
    
    private var moveView:CirclePointView?
    let size:CGFloat = 30
    
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
            moveView.center = touch
            setNeedsDisplay()
        }
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
        
        UIColor.white.setStroke()
        bezierPath.stroke()
        
    }
    
}
