//
//  AppDelegate.swift
//  MyFriendsRoom
//
//  Created by Ал on 24.08.2018.
//  Copyright © 2018 UDx. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import CoreData
import GoogleMaps
import GooglePlaces
import FBSDKCoreKit
var yourFriendsOfFriendsArray = [String: String]()
var counterbadge:Int = 0
//var counterbadge = Int()
var reportMethod = String()
var itWasRegistration = false
var notificationUid = String()
var notificationCategory = String()
var opening = String()
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    var restrictRotation:UIInterfaceOrientationMask = .portrait
    
    static let NOTIFICATION_URL = "https://gcm-http.googleapis.com/gcm/send"
    static var DEVICEID = String()
    @objc static let SERVERKEY = "AAAAXCtXNGw:APA91bFjjAQjJQu6kpeD9pnrmCCtpc2j12MUANuawpbtE9PZW4bcTbTGn0M1W5agupQOvzBJaQJhkmZ-z52lNAO670Bvwk0YB5i1vxo9Wmem039HhknRZywQJzQValidG-LM1h-6lEbK"
    
    
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask
    {
//        UIApplication.shared.applicationIconBadgeNumber += 6
        return self.restrictRotation
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
        UserDefaults.standard.synchronize()
        
        // Override point for customization after application launch.
        GMSPlacesClient.provideAPIKey("AIzaSyA6nRjxNn_QUVDuBWdVAbTeZ2NZpWQdECs")
        FirebaseApp.configure()
        sleep(1);
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        //        var restrictRotation:UIInterfaceOrientationMask = .portrait
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        //window?.rootViewController = UINavigationController(rootViewController: MessagesController())
        //window?.rootViewController = UINavigationController(rootViewController: welcomeController())
        window?.rootViewController = TabBarController()
        
        
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            
            let option: UNAuthorizationOptions = [.alert,.badge,.sound]
            UNUserNotificationCenter.current().requestAuthorization(options: option, completionHandler: { (bool, err) in
                
            })
        }else {
            let settings : UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
//        if counterbadge != nil {
//            counterbadge += 22
//        } else {
//            counterbadge = 16
//        }
//        UIApplication.shared.applicationIconBadgeNumber =
        application.registerForRemoteNotifications()
//        UIApplication.shared.applicationIconBadgeNumber += 10
//        NotificationCenter.default.addObserver(self, selector: #selector(getter: AppDelegate.SERVERKEY), name: NSNotification.Name.InstanceIDTokenRefresh, object: nil)
//        counterbadge = 0
        
        
        return true
    }
    
    
//    func badgeCounter(){
//        if #available(iOS 10.0, *) {
//            UNUserNotificationCenter.current().delegate = self
//
//            let option: UNAuthorizationOptions = [.alert,.badge,.sound]
//            UNUserNotificationCenter.current().requestAuthorization(options: option, completionHandler: { (bool, err) in
//
//            })
//        }else {
//            let settings : UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert,.badge,.sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//
//        }
//
//        application.registerForRemoteNotifications()
//        UIApplication.shared.applicationIconBadgeNumber = 1
//        //        counterbadge = 0
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: [UIApplicationOpenURLOptionsKey.annotation])
        return handled
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber += 1
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        recount()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("users").child(uid)
        let values = ["counterbadge": counterbadge]
        ref.updateChildValues(values)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didEnterBackground"), object: nil)
//        TabBarController().signOutDisconect(id: uid)
        UIApplication.shared.applicationIconBadgeNumber = counterbadge
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber += 3
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "opening"), object: nil)
        
//        Database.database().isPersistenceEnabled = true
//        if Database.database().isPersistenceEnabled == true {
//            TabBarController().setActiveDisconectStatus()
//        }
//        UIApplication.shared.applicationIconBadgeNumber += 4
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        application.applicationIconBadgeNumber = 0
//        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    @objc func recount(){
        counterbadge = unreadMessagesCount + unseenNotificationsCount
    }
    func applicationWillTerminate(_ application: UIApplication) {
//        UIApplication.shared.applicationIconBadgeNumber += 5
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    /*lazy var persistentContainer: NSPersistentContainer = {
     /*
     The persistent container for the application. This implementation
     creates and returns a container, having loaded the store for the
     application to it. This property is optional since there are legitimate
     error conditions that could cause the creation of the store to fail.
     */
     let container = NSPersistentContainer(name: "MyFriendsRoom")
     container.loadPersistentStores(completionHandler: { (storeDescription, error) in
     if let error = error as NSError? {
     // Replace this implementation with code to handle the error appropriately.
     // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
     
     /*
     Typical reasons for an error here include:
     * The parent directory does not exist, cannot be created, or disallows writing.
     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
     * The device is out of space.
     * The store could not be migrated to the current model version.
     Check the error message to determine what the actual problem was.
     */
     fatalError("Unresolved error \(error), \(error.userInfo)")
     }
     })
     return container
     }()*/
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        /*  let context = persistentContainer.viewContext
         if context.hasChanges {
         do {
         try context.save()
         } catch {
         // Replace this implementation with code to handle the error appropriately.
         // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         let nserror = error as NSError
         fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
         }
         }*/
    }
    
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        guard let newToken = InstanceID.instanceID().token() else {return}
        AppDelegate.DEVICEID = newToken
        connectToFCM()
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let token = InstanceID.instanceID().token() else {return}
        AppDelegate.DEVICEID = token
        print("token \(token)")
        connectToFCM()

    }
    
    
    
    func connectToFCM() {
//        UIApplication.shared.applicationIconBadgeNumber += 1
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        opening = "notification"
        let uid = response.notification.request.content.userInfo["uid"]
        if uid == nil {
            notificationUid = ""
        } else {
            notificationUid =  String(describing: uid!)
        }
//        notificationUid = "9IOGxjAl6eRc7IlPO1FIKi9HI6l1"
        let method = response.notification.request.content.userInfo["method"]
        if method == nil {
            notificationCategory = ""
        } else {
            notificationCategory = String(describing: method!)
        }
//        notificationCategory = "chat"
//        notificationCategory = "profile"
//        notificationCategory = "manamana"
    }

    
    
}

