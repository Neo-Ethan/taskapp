//
//  InputViewController.swift
//  taskapp
//
//  Created by Hiro Katoh on 2022/12/21.
//

import UIKit
import RealmSwift    // 追加完了　chapter6.10
import UserNotifications   // 追加　Chapter 7.3

class InputViewController: UIViewController {
    
    @IBOutlet weak var category: UITextField!
    
    //Chapter 6.8
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()  //追加完了　chapter6.10
    var task: Task!  // 追加完了  chapter6.8
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Chapter 6.10
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title       //タイトル内容をtextFielに反省する指示
        contentsTextView.text = task.contents
        datePicker.date = task.date
        category.text = task.category
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!   //タイトル入力した内容を保存する指示
            self.task.contents = self.contentsTextView.text //内容入力した内容を保存する指示
            self.task.date = self.datePicker.date          //日付入力した内容を保存する指示
            self.task.category = self.category.text!
            self.realm.add(self.task, update: .modified)
        }
        
        setNotification(task: task)   // 追加 Chapter 7.3
        
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録する　--- ここから ---　追加 Chapter 7.3
    func setNotification(task: Task){
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定（中身が無い場合メッセージ無しで音だけの通知になるので「（××なし）」を表示する）
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = task.contents
        } else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動する triger(日付マッチ)を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
  
        // identifier, content, triggerからローカル通知を作成(identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) {(error) in
            print(error ?? "ローカル通知登録 OK") // error が nil ならローカル通知の登録に成功したと表示します。error が存在すれば error を表示します。
        }
            
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    } // --- ここまで追加 --- Chapter 7.3
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
}

// Do any additional setup after loading the view.


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

