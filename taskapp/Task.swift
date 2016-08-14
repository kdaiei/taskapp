//
//  Task.swift
//  taskapp
//
//  Created by kobayashi on 2016/08/12.
//  Copyright © 2016年 hirotaka.kobayashi. All rights reserved.
//

import RealmSwift

class Task: Object {
    // 管理用 ID。プライマリーキー
    dynamic var id = 0
    
    // タイトル
    dynamic var title = ""
    
    // カテゴリー
    dynamic var category = ""
    
    // 内容
    dynamic var contents = ""
    
    // 日時
    dynamic var date = NSDate()
    
    // id をプライマリキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
