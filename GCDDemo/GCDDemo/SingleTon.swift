//
//  SingleTon.swift
//  GCDDemo
//
//  Created by Nino on 2018/2/23.
//  Copyright © 2018年 Nino. All rights reserved.
//

import UIKit

final class SingleTon: NSObject {
    static let shared = SingleTon()
    private override init() {}
    
    func func1() {
        print("单例中的 function")
    }
}
