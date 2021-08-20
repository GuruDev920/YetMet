//
//  AppDelegate.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import UIKit
import Firebase
import AudioToolbox.AudioServices
import IQKeyboardManagerSwift
import FBSDKCoreKit
import DropDown

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.clearBadgeNumber()
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge, .carPlay ]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
        application.registerForRemoteNotifications()
        
        IAPManager.shared.startObserving()
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
        Global_SetGlassEffect()
        
        Messaging.messaging().delegate = self
        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        DropDown.startListeningToKeyboard()
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        IAPManager.shared.stopObserving()
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
    
    private func clearBadgeNumber() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //AudioServicesPlayAlertSound(1110)
        SoundManager.shared.playMessageSound()
        
        if let pushType = userInfo["Type"] as? String {
            if pushType == PushNotificationType.message {//push notification for message
                if application.applicationState == .inactive || application.applicationState == .background {
                    USERDEFAULTS.set(userInfo["userId"], forKey: lc_senderId)
                    USERDEFAULTS.synchronize()
                }
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.displayMessage), object: nil, userInfo: userInfo)
                
            } else {// push notification for chat request
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationName.chatRequest), object: nil, userInfo: userInfo)
            }
        }
    }


    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = ApplicationDelegate.shared.application(app, open: url, options: options)
        return handled
        
//        return FBAppCall.handleOpen(url, sourceApplication: "")
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {

        completionHandler()
    }
}
    // [END ios_10_message_handling]

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken)")
        UserDefaults.standard.setValue(fcmToken, forKey: "token")
    }

    /*func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }*/
}
