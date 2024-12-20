//
//  NotificationManager.swift
//  Alarma
//
//  Created by alumno on 29/11/24.
//

import Foundation
import UserNotifications

// Alert check every minute
let timeInterval = 60

class NotificationManager {
    static let shared = NotificationManager()
    
    //Allow the app to send notifications
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error whne requesting permission \(error.localizedDescription)")
            } else if granted {
                print("Permission granted")
            } else {
                print("Permiso denied")
            }
        }
    }
    
    func schedulePriceNotification(targetPrice: Double, crypto: CryptoCurrency) {
        //Notification Content
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = "\(crypto.name) price has been reached"
        content.body = "\(crypto.name) has just reached \(targetPrice). Click to view more."
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(crypto.name) at \(targetPrice).")
            }
        }
        
    }
    
    func schedulePercentageChangeNotification(targetChange: Double, crypto: CryptoCurrency) {
        //Notification Content
        let content = UNMutableNotificationContent()
        content.sound = .default
        if targetChange >= 0 {
            content.title = "\(crypto.name) price has increased by \(targetChange * 100)%"
            content.body = "\(crypto.name) has reached \((((CryptoModel.isEuro() ? crypto.currentPrice!["eur"] : crypto.currentPrice!["usd"])!)) * (1 + targetChange)). Click to view more."
        } else {
            content.title = "\(crypto.name) price has decreased by \(-targetChange * 100)%"
            content.body = "\(crypto.name) has dropped to \((((CryptoModel.isEuro() ? crypto.currentPrice!["eur"] : crypto.currentPrice!["usd"])!)) * (1 + targetChange)). Click to view more."
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully for \(crypto.name) to change by \(targetChange * 100).")
            }
        }
    }
    
    func startMonitoringPrice(crypto: CryptoCurrency, price: Double) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterval), repeats: true) { timer in
            crypto.updateDetails()
            guard let currentPrice = (CryptoModel.isEuro() ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"]) else {
                print("Failed to fetch price for \(crypto.name).")
                return
            }
            if currentPrice >= price {
                timer.invalidate()
                self.schedulePriceNotification(targetPrice: price, crypto: crypto)
            }
        }
    }
    
    func startMonitoringPercentage(crypto: CryptoCurrency, price: Double, percentage: Double) {
        Timer.scheduledTimer(withTimeInterval: TimeInterval(timeInterval), repeats: true) { timer in
            crypto.updateDetails()
            guard let currentPrice = (CryptoModel.isEuro() ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"]) else {
                print("Failed to fetch price for \(crypto.name).")
                return
            }
            if percentage < 0 {
                if currentPrice <= price * (1 - percentage) {
                    self.schedulePercentageChangeNotification(targetChange: percentage, crypto: crypto)
                }
            } else {
                if currentPrice >= price * (1 + percentage) {
                    self.schedulePercentageChangeNotification(targetChange: percentage, crypto: crypto)
                }
            }
        }
    }
}
