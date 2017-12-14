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
                moveView?.setTouch()
                break
            }
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let moveView = moveView{
            guard let touch = touches.first?.location(in: self) else{return}
            
            switch moveView{
            case circleViews[0]:
                let intersect1 = doIntersect(p1: touch,
                                         q1: circleViews[3].center,
                                         p2: circleViews[1].center,
                                         q2: circleViews[2].center)
                let intersect2 = doIntersect(p1: touch,
                                         q1: circleViews[1].center,
                                         p2: circleViews[2].center,
                                         q2: circleViews[3].center)
                if intersect1 || intersect2{
                    return
                }
                
                break
            case circleViews[1]:
                let intersect1 = doIntersect(p1: touch,
                                             q1: circleViews[0].center,
                                             p2: circleViews[2].center,
                                             q2: circleViews[3].center)
                let intersect2 = doIntersect(p1: touch,
                                             q1: circleViews[2].center,
                                             p2: circleViews[0].center,
                                             q2: circleViews[3].center)
                if intersect1 || intersect2{
                    return
                }
                break
            case circleViews[2]:
                let intersect1 = doIntersect(p1: touch,
                                             q1: circleViews[1].center,
                                             p2: circleViews[0].center,
                                             q2: circleViews[3].center)
                let intersect2 = doIntersect(p1: touch,
                                             q1: circleViews[3].center,
                                             p2: circleViews[1].center,
                                             q2: circleViews[0].center)
                if intersect1 || intersect2{
                    return
                }
                break
            case circleViews[3]:
                let intersect1 = doIntersect(p1: touch,
                                             q1: circleViews[2].center,
                                             p2: circleViews[0].center,
                                             q2: circleViews[1].center)
                let intersect2 = doIntersect(p1: touch,
                                             q1: circleViews[0].center,
                                             p2: circleViews[1].center,
                                             q2: circleViews[2].center)
                if intersect1 || intersect2{
                    return
                }
                break
            default:
                break
            }
            
            moveView.center = touch
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveView?.endTouch()
        moveView = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        moveView?.endTouch()
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

extension DrawView{
    fileprivate func onSegment(p:CGPoint,q:CGPoint,r:CGPoint)->Bool{
        if (q.x <= max(p.x, r.x) && q.x >= min(p.x, r.x) &&
            q.y <= max(p.y, r.y) && q.y >= min(p.y, r.y)){
            return true
        }
        return false
    }
    
    fileprivate func orientation(p:CGPoint,q:CGPoint,r:CGPoint) -> Int {
        let val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)
        
        if (val == 0){
            return 0
        }  // colinear
        
        return val > 0 ? 1: 2 // clock or counterclock wise
    }
    
    fileprivate func doIntersect(p1:CGPoint,q1:CGPoint,p2:CGPoint,q2:CGPoint)-> Bool{
        // Find the four orientations needed for general and
        // special cases
        let o1 = orientation(p: p1, q: q1, r: p2)
        let o2 = orientation(p: p1, q: q1, r: q2)
        let o3 = orientation(p: p2, q: q2, r: p1)
        let o4 = orientation(p: p2, q: q2, r: q1)
        
        // General case
        if (o1 != o2 && o3 != o4){
            return true
        }

        // Special Cases
        // p1, q1 and p2 are colinear and p2 lies on segment p1q1
        if (o1 == 0 && onSegment(p: p1, q: p2, r: q1)){
            return true
        }
        
        // p1, q1 and p2 are colinear and q2 lies on segment p1q1
        if (o2 == 0 && onSegment(p: p1, q: q2, r: q1)){
            return true
        }
        
        // p2, q2 and p1 are colinear and p1 lies on segment p2q2
        if (o3 == 0 && onSegment(p: p2, q: p1, r: q2)){
            return true
        }
        
        // p2, q2 and q1 are colinear and q1 lies on segment p2q2
        if (o4 == 0 && onSegment(p: p2, q: q1, r: q2)){
             return true
        }
        
        return false // Doesn't fall in any of the above cases
        
    }
    
}
