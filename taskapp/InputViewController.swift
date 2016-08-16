
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
    
    @IBOutlet weak var errorMes: UILabel!
    

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
        
        let leftButton = UIBarButtonItem(title: "＜ 戻る", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(InputViewController.goBefore))
        let rightButton = UIBarButtonItem(title: "保存 ", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(InputViewController.goSave))
        self.navigationItem.leftBarButtonItems = [leftButton]
        self.navigationItem.rightBarButtonItems = [rightButton]
        
        var errFontSize = 13
        let myNativeBoundSize: CGSize = UIScreen.mainScreen().nativeBounds.size
        print(myNativeBoundSize.width)
        switch myNativeBoundSize.width {
            case 640:
                errFontSize = 13
            case 750:
                errFontSize = 16
            case 1242:
                errFontSize = 17
            default:
                errFontSize = 13
                break
        }
        print(errFontSize)
        errorMes.font = UIFont.systemFontOfSize(CGFloat(errFontSize))
        errorMes.text = ""
    }
    
    
    
    // 入力エラーチェック
    func checkError() -> Bool {
        var errCnt:Int = 0
        var resultArray:[String] = []
        let titleStr:String = "タイトル"
        let contentsStr:String = "内容"
        let categoryStr:String = "カテゴリ"
        var errFlag = false
        
        if "" == self.titleTextField.text! {
            resultArray.append(titleStr)
            errCnt += 1
        }
        
        if "" == self.selectCategory! {
            resultArray.append(categoryStr)
            errCnt += 1
        }

        if "" == self.contentsTextView.text! {
            resultArray.append(contentsStr)
            errCnt += 1
        }
        
        if 0 < errCnt {
            let csvRow = resultArray.joinWithSeparator(",")
            errorMes.text = csvRow + "が入力されていません"
            errFlag = true
        }
        
        return errFlag
    }
    
    // 戻るボタンを押下
    func goBefore() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goSave() {
        if checkError() {
            return
        }
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.selectCategory!
            self.realm.add(self.task, update: true)
        }
        setNotification(task)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 画面遷移時の動作
    override func viewWillAppear(animated: Bool) {
        if !selectCategoryFlag {
            //print("viewWillAppear kita!")
            selectCategory = appDelegate.message
            setCategoryBtnLabel(selectCategory!)
            errorMes.text = ""
        }
    }
    
    // カテゴリボタンのラベルを変更
    func setCategoryBtnLabel(str:String) {
        if "" == str{
            categoryButton.setTitle("カテゴリを選択", forState: .Normal)
        } else {
            categoryButton.setTitle(str, forState: .Normal)
        }
    }
    
    // 画面遷移時の動作
    override func viewWillDisappear(animated: Bool) {

        if !selectCategoryFlag { // カテゴリ選択画面に遷移するときは保存しない
            selectCategoryFlag = true
        } else {
            selectCategoryFlag = false
        }
        errorMes.text = ""
        super.viewWillDisappear(animated)
    }
    
    
    // キーボードを閉じる
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // タスクのローカル通知を設定する
    func setNotification(task: Task) {
        
        // すでに同じタスクが登録されていたらキャンセルする
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
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
        categoryViewController.categoryStr = selectCategory!

    }
}
