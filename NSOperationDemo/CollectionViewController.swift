//
//  CollectionViewController.swift
//  NSOperationDemo
//
//  Created by Nino on 2017/12/18.
//  Copyright © 2017年 Nino. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let imageLoadQueue = OperationQueue()
    
    var imageOps = [(Item, Operation?)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // set queue
        imageLoadQueue.maxConcurrentOperationCount = 2
        imageLoadQueue.qualityOfService = .userInitiated
        
        // 使用 map 函数改造，创建imageOps
        imageOps = Item.creatItems(count: 100).map({ (images) -> (Item, Operation?) in
            return (images, nil)
        })
        
        self.collectionView?.reloadData()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageOps.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
        cell.imgView.image = nil
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = cell as! ImageCell
        let (item, operation) = imageOps[indexPath.row]
        
        operation?.cancel()
        
        weak var weakCell = cell
        
        let newOp = ImageLoadOperation(forItem: item) { (image) in
            DispatchQueue.main.async {
                weakCell?.imgView.image = image
            }
        }
        
        imageLoadQueue.addOperation(newOp)
        imageOps[indexPath.row] = (item, newOp)
    }

    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = UIScreen.main.bounds.width * 0.5 - 5.0
        return CGSize(width: w, height: w)
    }

}
