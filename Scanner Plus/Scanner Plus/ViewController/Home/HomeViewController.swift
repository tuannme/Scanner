//
//  HomeViewController.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/11/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

class HomeViewController: DUTabbarViewController {

    @IBOutlet weak var tabbarView: DUTabbarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.bringSubview(toFront: tabbarView)
        
        let sb = UIStoryboard.init(name: "Camera", bundle: nil)
        let view1 = sb.instantiateViewController(withIdentifier: "TabView1")
        let view2 = sb.instantiateViewController(withIdentifier: "TabView2")
        let view3 = sb.instantiateViewController(withIdentifier: "TabView3")
        let view4 = sb.instantiateViewController(withIdentifier: "TabView4")
        let view5 = sb.instantiateViewController(withIdentifier: "TabView5")
        self.viewControllers = [view1,view2,view3,view4,view5]
        
        tabbarView.setAnimation(animationType: .Bounce)
        tabbarView.tabbarAction = {
            index in
            let indexPath = IndexPath(item: index, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    override func didChangePage(index: Int) {
        tabbarView.setSelectPageIndex(index: index)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("HomeViewController didReceiveMemoryWarning")
    }
}



