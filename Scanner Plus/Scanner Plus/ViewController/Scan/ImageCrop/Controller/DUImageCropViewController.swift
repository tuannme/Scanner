//
//  DUImageCropViewController.swift
//  Scanner Plus
//
//  Created by Nguyen Manh Tuan on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class DUImageCropViewController: UIViewController {

    var points:[CGPoint] = []
    var image:UIImage?
    let drawView = DrawView(frame: UIScreen.main.bounds)
    let imageContainer = UIImageView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // config view
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor.darkGray
        
        //add imageView
        imageContainer.contentMode = .scaleAspectFit
        imageContainer.image = image
        view.addSubview(imageContainer)
        
        // add drawView
        self.view.addSubview(drawView)
        drawView.addPoints(points: points)
    
        // add barView
        let barView = UIView()
        barView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width, height: 50)
        barView.backgroundColor = UIColor.white
        view.addSubview(barView)
        
        let retakeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        let keepScanBtn = UIButton(frame: CGRect(x: UIScreen.main.bounds.width - 100, y: 0, width: 100, height: 50))
        barView.addSubview(retakeBtn)
        barView.addSubview(keepScanBtn)
        
        retakeBtn.setTitle("Retake", for: .normal)
        retakeBtn.setTitleColor(UIColor.orange, for: .normal)
        retakeBtn.addTarget(self, action: #selector(self.retakeAction), for: .touchUpInside)
        
        keepScanBtn.setTitle("Keep Scan", for: .normal)
        keepScanBtn.setTitleColor(UIColor.orange, for: .normal)
        keepScanBtn.addTarget(self, action: #selector(self.keepScanAction), for: .touchUpInside)
    }
    
    @objc func retakeAction(){

    }
    
    @objc func keepScanAction(){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
