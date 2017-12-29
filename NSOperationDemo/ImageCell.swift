//
//  ImageCell.swift
//  NSOperationDemo
//
//  Created by Nino on 2017/12/18.
//  Copyright © 2017年 Nino. All rights reserved.
//

import UIKit


class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    func setUpCell(image:UIImage) {
        imgView.image = image
    }
    
}
