//
//  ScannerViewController.swift
//  Scanner Plus
//
//  Created by Nguyen Manh Tuan on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func cropImageAction(_ sender: Any) {
        
        let cropImageVC = DUImageCropViewController()
        cropImageVC.image = #imageLiteral(resourceName: "background")
        cropImageVC.points = [CGPoint(x: 50, y: 100),
                              CGPoint(x: 250, y: 50),
                              CGPoint(x: 300, y: 400),
                              CGPoint(x: 40, y: 500)]
        
        self.navigationController?.pushViewController(cropImageVC, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
