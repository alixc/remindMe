//
//  AppDelegate.swift
//  remindMe
//
//  Created by Medi Assumani on 9/14/18.
//  Copyright © 2018 Yves Songolo. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import JLocationKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{
    
    var window: UIWindow?
    var navigationController: UINavigationController?
    var locationManager: CLLocationManager!
    var notificationCenter: UNUserNotificationCenter!
    let network = NetworkManager.shared
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        isUserLoggedIn()
        configureUserLocation()
        configureLocalNotification()
        FirebaseApp.configure()
        
        return true
    }
    
    
    /// Method to get authorization from the user for sending push notifications
    fileprivate func configureLocalNotification(){
        
        self.notificationCenter = UNUserNotificationCenter.current()
        notificationCenter?.delegate = self
        let notificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter?.requestAuthorization(options: notificationOptions, completionHandler: { (granted, error) in
            if !granted{
                print("Error Found : Permision Not Granted")
            }
        })
    }
    
    /// Method to handle and set up the local notification
    fileprivate func handleEvent(forRegion region: CLRegion!, body: String, title: String){
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder Alert : \(title)"
        content.body = body
        content.sound = UNNotificationSound.default()
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)
        let identifier = region.identifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request, withCompletionHandler: { (error) in
            if error != nil {
                print("Error adding notification with identifier: \(identifier)")
            }
        })
    }
    
    
    /// This functions requests the needed access from the user in order to use the user'slocation
    fileprivate func configureUserLocation(){
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        
        // Configuring User Location
        if (CLLocationManager.locationServicesEnabled())
        {
            self.locationManager = CLLocationManager()
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
        }
    }
    
    
    /// Method to make the api call to Firebase and retrieve the reminder and group to show on the notification
    fileprivate func prepareForNotification(forRegion region: CLRegion){
        
        let identifier = region.identifier
        ReminderServices.show(identifier) { (reminder) in
            guard let reminder = reminder else {return}
            GroupServices.show(reminder.groupId, completion: { (group) in
                guard let group = group else {return}
                self.handleEvent(forRegion: region, body: reminder.time, title:group.name)
            })
        }
    }
    
    
    // This function checks if the user has logged in before on the app to avoid re-showing the login screen
    fileprivate func isUserLoggedIn(){
        
        if UserDefaults.standard.value(forKey: "current") != nil{
            
            // Checking the internet status... will be ignored if there is connection
            NetworkManager.isUnReachable { (network, isUnreachable) in
                if isUnreachable{
                    self.showOfflinePage()
                }else{
                    self.showMainPage()
                }
            }
        }
    }
    

    /// Method to render the offline page if there is no internet connection
    fileprivate func showOfflinePage(){
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window{
            let destinationVC = OfflineViewController()
            navigationController = UINavigationController(rootViewController: destinationVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }

    /// Method to render the main page if there is internet connection
    fileprivate func showMainPage(){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            let groupListVC = GroupListViewController()
            navigationController = UINavigationController(rootViewController: groupListVC)
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}

extension AppDelegate: CLLocationManagerDelegate{
    
    // - MARK: CORE LOCATION METHODS
    
    
    /// Function to trigger local notification when the user enters radius of the provided location
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
        // checks if the user is re-connected after entering the region
        network.reachability.whenReachable = { reachability in
            self.prepareForNotification(forRegion: region)
        }
    }

    /// Function to trigger local notification when the user exits radius of the provided location
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
        // checks if the user is re-connected after entering the region
        network.reachability.whenReachable = { reachability in
            self.prepareForNotification(forRegion: region)
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // when app is open and in foregroud
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        // get the notification identifier to respond accordingly
        let identifier = response.notification.request.identifier
        
        // do what you need to do
        print(identifier)
        // ...
    }
}
