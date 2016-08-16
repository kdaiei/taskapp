//
//  Category.swift
//  taskapp
//
//  Created by kobayashi on 2016/08/14.
//  Copyright © 2016年 hirotaka.kobayashi. All rights reserved.
//

//import Foundation
//
//
//class Category {
//    var id: Int
//    var category: String
//    
//    init(id: Int, category: String) {
//        self.id = id
//        self.category = category
//    }
//}

import RealmSwift

class Category: Object {
    // 管理用 ID。プライマリーキー
    dynamic var id = 0
    
    // タイトル
    dynamic var category = ""

    
    // id をプライマリキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
