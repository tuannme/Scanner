//
//  UIApplication.swift
//  Scanner Plus
//
//  Created by Nguyen Manh Tuan on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

extension UIApplication {

    func setUpNavigation(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeNavi = storyboard.instantiateViewController(withIdentifier: "NavigationHomeViewController") as! UINavigationController
        homeNavi.interactivePopGestureRecognizer?.delegate = nil
        homeNavi.navigationBar.isHidden = true
    }

}
