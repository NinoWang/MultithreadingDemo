//
//  DownloadImgViewController.swift
//  GCDDemo
//
//  Created by Nino on 2018/2/22.
//  Copyright © 2018年 Nino. All rights reserved.
//

import UIKit

class DownloadImgViewController: ViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let globalQueue = DispatchQueue.global()
        
        globalQueue.async {
            if let url = URL.init(string: "https://placebeard.it/200/150") {
                do {
                    let imageData = try Data(contentsOf: url)
                    let image = UIImage(data: imageData)
                    
                    DispatchQueue.main.async {
                        self.imgView.image = image
                        self.imgView.sizeToFit()
                    }
                    
                } catch {
                    print(error)
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
