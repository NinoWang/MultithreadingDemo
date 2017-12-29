//
//  Item.swift
//  NSOperationDemo
//
//  Created by Nino on 2017/12/28.
//  Copyright © 2017年 Nino. All rights reserved.
//

import UIKit

class Item {
    let count: Int
    
    init(number :Int) {
        count = number
    }
    
    static func creatItems(count :Int) -> [Item] {
        var items = [Item]()
        
        for index in 1...count {
            items.append(Item(number: index))
        }
        return items
    }
    
    func imageUrl() -> URL? {
        return URL(string: "https://placebeard.it/300/300")
    }

}
