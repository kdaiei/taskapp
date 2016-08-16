//
//  InputViewController.swift
//  taskapp
//
//  Created by kobayashi on 2016/08/10.
//  Copyright © 2016年 hirotaka.kobayashi. All rights reserved.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {

    var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var selectCategoryFlag: Bool = false

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var contentsTextView: UITextView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var categoryButton: UIButton!

    @IBAction func selectCategoryButton(sender: AnyObject) {
        selectCategoryFlag = true
    }

    
    
    let realm = try! Realm()
    var task:Task!
    
    var selectCategory:String? = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        selectCategory = task.category
        setCategoryBtnLabel(selectCategory!)
        selectCategoryFlag = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //
    override func viewWillAppear(animated: Bool) {
        if !selectCategoryFlag {
            print("viewWillAppear kita!")
            selectCategory = appDelegate.message
            setCategoryBtnLabel(selectCategory!)
        }
    }
    
    //
    func setCategoryBtnLabel(str:String) {
        if "" == str{
            categoryButton.setTitle("カテゴリを選択", forState: .Normal)
        } else {
            categoryButton.setTitle(str, forState: .Normal)
        }
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        // カテゴリ選択画面に遷移するときは保存しない
        if !selectCategoryFlag {
            //print("viewWillDisappear kita!")
            //print("viewWillAppear kita!")
//            selectCategory = appDelegate.message
            if "" == selectCategory {
                categoryButton.titleLabel?.text = "カテゴリを選択"
            } else {
                categoryButton.titleLabel?.text = selectCategory
            }
            
            
            try! realm.write {
                self.task.title = self.titleTextField.text!
                self.task.contents = self.contentsTextView.text
                self.task.date = self.datePicker.date
                print("selectCategory = \(selectCategory!)")
                self.task.category = self.selectCategory!
                self.realm.add(self.task, update: true)
            }
            
            setNotification(task)
            
            selectCategoryFlag = true
        } else {
            selectCategoryFlag = false
        }
        
        super.viewWillDisappear(animated)
    }
    
    
    func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
    // タスクのローカル通知を設定する
    func setNotification(task: Task) {
        
        // すでに同じタスクが登録されていたらキャンセルする
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            print(task.id)
            if notification.userInfo!["id"] as! Int == task.id {
                UIApplication.sharedApplication().cancelLocalNotification(notification)
                break
            }
        }
        
        let notification = UILocalNotification()
        
        notification.fireDate = task.date
        notification.timeZone = NSTimeZone.defaultTimeZone()
        notification.alertBody = "\(task.title)"
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["id":task.id]
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    
    // segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let categoryViewController:CategoryViewController = segue.destinationViewController as! CategoryViewController
        //print("segue = \(selectCategory!)")
        categoryViewController.categoryStr = selectCategory!

    }
}
