//
//  AppDelegate.swift
//  taskapp
//
//  Created by Hiro Katoh on 2022/12/18.
//

import UIKit
import UserNotifications   // 追加　Chapter 7.2

@main                             // UNUserNotificationCenterDelegateを追加 Chapter 7.5
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // ユーザーに通知の許可を求める
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // enable or disable features based on authorization
        } // --- ここまで追加 --- Chapter 7.2
        center.delegate = self   // 追加　Chapter7.5  フォアグラウンドでも通知
        
        return true
    }
    
    // アプリがフォアグラウンドの時に通知を受け取ると呼ばれるメソッド   --- ここから --- Chapter7.5
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    } // --- ここまで追加 --- Capter7.5
}



// MARK: UISceneSession Lifecycle

func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
}

func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}

