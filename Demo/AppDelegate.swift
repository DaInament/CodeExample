//
//  AppDelegate.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        /// Только сегодня узнал, что парни из Apple любят издевательства - нельзя просто взять и создать приложуху без xib/story, начинается какая то фигня с размером window...
        ///По приколу можете удалить LaunchScreen.storyboard и из .plist ссылку на него и запустить
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = LoginScreen()
        window?.makeKeyAndVisible()
        return true
    }
}

