//
//  DUTabbarViewController.swift
//  Scanner Plus
//
//  Created by TuanNM on 12/12/17.
//  Copyright © 2017 TuanNM. All rights reserved.
//

import UIKit

protocol DUTabbarViewControllerProtocol {
    func didChangePage(index:Int)
}

class DUTabbarViewController: UIViewController,DUTabbarViewControllerProtocol {

    var collectionView: UICollectionView!
    private var _viewControllers:[UIViewController] = []
    private let identifier = "itemCell"
    
    var viewControllers:[UIViewController] {
        get{
            return _viewControllers
        }
        
        set (arrViewControllers){
            _viewControllers = arrViewControllers
            for vc in viewControllers{
                self.addChildViewController(vc)
            }
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.sectionInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        flowLayout.scrollDirection = .horizontal
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50), collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        
        self.view.addSubview(collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("DUTabbarViewController didReceiveMemoryWarning")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = collectionView.frame.width
        let page = collectionView.contentOffset.x / pageWidth
        didChangePage(index: Int(page))
    }
    
    func didChangePage(index: Int) {
        // for subclass implement
    }
}

extension DUTabbarViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewControllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        let vc = viewControllers[indexPath.row]
        cell.addSubview(vc.view)
        return cell
    }
}


extension DUTabbarViewController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 50)
    }
}
