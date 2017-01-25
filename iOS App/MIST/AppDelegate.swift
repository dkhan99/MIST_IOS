//
//  AppDelegate.swift
//  MIST
//
//  Created by Muhammad Doukmak on 12/26/16.
//  Copyright © 2016 Muhammad Doukmak. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseDatabase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
    var storyboard: UIStoryboard?
    var window: UIWindow?
    var ref:FIRDatabaseReference!
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        self.ref = FIRDatabase.database().reference()
        print("Time is .... ")
        self.storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        self.ref.child("competition").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? NSDictionary {
                UserDefaults.standard.setValue(value, forKey: "competitions")
            }
        })
        if let user = FIRAuth.auth()?.currentUser {
            self.ref.child("registered-user").child(user.uid).observe(.value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                UserDefaults.standard.set(value, forKey: "user")
                self.ref.child("team").child((value!.value(forKey: "team")! as? String)!).observe(.value, with: { (snapshot) in
                    let teamObject = snapshot.value as! NSDictionary
                    UserDefaults.standard.set(teamObject, forKey: "team")
                    self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "MyTabBarController")
                })
                
            })
            
            UserDefaults.standard.set(false, forKey: "isGuest")
        } else {
            self.window?.rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "SelectRoleVC")
        }
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
            
        }
        
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.tokenRefreshNotification),
                                               name: .firInstanceIDTokenRefresh,
                                               object: nil)
        UserDefaults.standard.set("nothing", forKey: "data")
        print("nothing")
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        print("didRecieveRemoteNotification!!!!")
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        var currentNotifications:[NSDictionary] = []
        if (UserDefaults.standard.value(forKey: "notifications") != nil) {
            currentNotifications = UserDefaults.standard.value(forKey: "notifications") as! [NSDictionary]
        }
            currentNotifications.insert(["title":(((userInfo["aps"] as! NSDictionary)["alert"] as! NSDictionary!)["title"] as! String)], at: 0)
        UserDefaults.standard.set(currentNotifications, forKey: "notifications")
        completionHandler(.newData)
    }
    func connectToFcm() {
        // Won't connect since there is no token
        guard FIRInstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        FIRMessaging.messaging().disconnect()
        
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }
    }
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
        }
        
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
        print("Entering background")
        UserDefaults.standard.set(false, forKey: "gotmessage")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        connectToFcm()
        print(UserDefaults.standard.value(forKey: "gotmessage") ?? "nil")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
//        NSLog("got something")
//        var currentNotifications:[NSDictionary] = []
//        if (UserDefaults.standard.value(forKey: "notifications") != nil) {
//            currentNotifications = UserDefaults.standard.value(forKey: "notifications") as! [NSDictionary]
//        }
//        currentNotifications.append(["title":((remoteMessage.appData as NSDictionary)["title"] as! String)])
//        UserDefaults.standard.set(currentNotifications, forKey: "notifications")
    }
}
