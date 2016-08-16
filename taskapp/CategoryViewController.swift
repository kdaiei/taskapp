//
//  categoryViewController.swift
//  taskapp
//
//  Created by kobayashi on 2016/08/14.
//  Copyright © 2016年 hirotaka.kobayashi. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    let realm = try! Realm()
    let cate = Category()
    let black     = UIColor.blackColor()
    let lightGray = UIColor.lightGrayColor()
    var categoryStr:String = ""

    var categoryArray = try! Realm().objects(Category)
    
    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var categoryName: UILabel!
    
    @IBAction func AddCategoryButton(sender: UIButton) {
        let alert = UIAlertController(title: "カテゴリ追加", message: "カテゴリを入力してください", preferredStyle: .Alert)
        
        let saveAction = UIAlertAction(title: "追加", style: .Default) { (action:UIAlertAction!) -> Void in
            
            // 入力したカテゴリを取得
            let textField = alert.textFields![0] as UITextField
            self.categoryStr = textField.text!
            
            // 重複するデータが内科確認
            let aCategoryArray = try! Realm().objects(Category).filter("category == '\(self.categoryStr)'")
            if 0 != aCategoryArray.count {
                return
            }
            
            // データベースに保存
            print(self.categoryStr)
            try! self.realm.write {
                if self.categoryArray.count != 0 {
                    self.cate.id = self.categoryArray.max("id")! + 1
                }
                self.cate.category = self.categoryStr
                self.realm.add(self.cate, update: true)
            }
            
            self.categoryTableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .Default) { (action:UIAlertAction!) -> Void in
        }
        
        // UIAlertControllerにtextFieldを追加
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("viewDidLoad = \(categoryStr)")
        if "" == categoryStr {
            categoryName.textColor = lightGray
        } else {
            categoryName.textColor = black
            categoryName.text = categoryStr
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    // データの数（＝セルの数）を返すメソッド
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    // 各セルの内容を返すメソッド
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let catcell = tableView.dequeueReusableCellWithIdentifier("categoryCell", forIndexPath: indexPath)
        
        let aCategory = categoryArray[indexPath.row]
        // Cellに値を設定する。
        
        catcell.textLabel?.text = aCategory.category
        
        return catcell
    }
    
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cat = categoryArray[indexPath.row]
        categoryName.textColor = black
        categoryName.text = cat.category
        
        appDelegate.message = cat.category
    }
    
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath)-> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            // データベースから削除する
            try! realm.write{
                self.realm.delete(self.categoryArray[indexPath.row])
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        }
    }
    


    
}
