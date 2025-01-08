//
//  CryptoCurrency.swift
//  StockViewer
//
//  Created by alumno on 2/12/24.
//

import Foundation
import UserNotifications
import BackgroundTasks

let priceMonitoringTaskIdentifier = "com.example.priceMonitoring"
let percentageMonitoringTaskIdentifier = "com.example.percentageMonitoring"

class NotificationManager {
    static let shared = NotificationManager()

    private var activePriceMonitoringTasks = [String: (crypto: CryptoCurrency, price: Double, increase: Bool, euro: Bool)]()
    private var activePercentageMonitoringTasks = [String: (crypto: CryptoCurrency, price: Double, percentage: Double, euro: Bool)]()

    // register background tasks
    func registerBackgroundTasks() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: priceMonitoringTaskIdentifier, using: nil) { task in
            self.handlePriceMonitoringTask(task: task as! BGAppRefreshTask)
        }

        BGTaskScheduler.shared.register(forTaskWithIdentifier: percentageMonitoringTaskIdentifier, using: nil) { task in
            self.handlePercentageMonitoringTask(task: task as! BGAppRefreshTask)
        }
    }

    // request notification authorization
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error when requesting permission \(error.localizedDescription)")
            } else if granted {
                print("Permission granted")
            } else {
                print("Permission denied")
            }
        }
    }

    // schedule a price notification when the target price is reached
    func schedulePriceNotification(targetPrice: Double, crypto: CryptoCurrency) {
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

    // schedule a notification when the target percentage change is reached
    func schedulePercentageChangeNotification(targetChange: Double, crypto: CryptoCurrency, euro: Bool) {
        let content = UNMutableNotificationContent()
        content.sound = .default
        if targetChange >= 0 {
            content.title = "\(crypto.name) price has increased by \(targetChange * 100)%"
            content.body = "\(crypto.name) has reached \((((euro ? crypto.currentPrice!["eur"] : crypto.currentPrice!["usd"])!)) * (1 + targetChange)). Click to view more."
        } else {
            content.title = "\(crypto.name) price has decreased by \(-targetChange * 100)%"
            content.body = "\(crypto.name) has dropped to \((((euro ? crypto.currentPrice!["eur"] : crypto.currentPrice!["usd"])!)) * (1 + targetChange)). Click to view more."
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

    // start monitoring price changes
    func startMonitoringPrice(crypto: CryptoCurrency, price: Double, increase: Bool, euro: Bool) {
        let taskID = UUID().uuidString
        activePriceMonitoringTasks[taskID] = (crypto, price, increase, euro)
        schedulePriceMonitoringTask(taskID: taskID)
    }

    // start monitoring percentage changes
    func startMonitoringPercentage(crypto: CryptoCurrency, price: Double, percentage: Double, euro: Bool) {
        let taskID = UUID().uuidString
        activePercentageMonitoringTasks[taskID] = (crypto, price, percentage, euro)
        schedulePercentageMonitoringTask(taskID: taskID)
    }

    // schedule a background task for monitoring price (for every 15 minutes)
    func schedulePriceMonitoringTask(taskID: String) {
        let request = BGAppRefreshTaskRequest(identifier: priceMonitoringTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Price monitoring task scheduled for \(taskID).")
        } catch {
            print("Failed to schedule price monitoring task: \(error.localizedDescription)")
        }
    }

    // handle price monitoring task
    private func handlePriceMonitoringTask(task: BGAppRefreshTask) {
        for (_, taskDetails) in activePriceMonitoringTasks {
            let (crypto, price, increase, euro) = taskDetails
            
            print("Checking price for \(crypto.name)")
            if let currentPrice = (euro ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"]) {
                if (increase && currentPrice >= price) || (!increase && currentPrice <= price) {
                    self.schedulePriceNotification(targetPrice: price, crypto: crypto)
                }
            }
        }

        task.setTaskCompleted(success: true)
    }

    // schedule a background task for monitoring percentage change (for every 15 minutes)
    func schedulePercentageMonitoringTask(taskID: String) {
        let request = BGAppRefreshTaskRequest(identifier: percentageMonitoringTaskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Percentage monitoring task scheduled for \(taskID).")
        } catch {
            print("Failed to schedule percentage monitoring task: \(error.localizedDescription)")
        }
    }

    // handle percentage monitoring task
    private func handlePercentageMonitoringTask(task: BGAppRefreshTask) {
        for (_, taskDetails) in activePercentageMonitoringTasks {
            let (crypto, price, percentage, euro) = taskDetails
            
            print("Checking percentage change for \(crypto.name)")
            if let currentPrice = (euro ? crypto.currentPrice?["eur"] : crypto.currentPrice?["usd"]) {
                if percentage < 0, currentPrice <= price * (1 + percentage) {
                    self.schedulePercentageChangeNotification(targetChange: percentage, crypto: crypto, euro: euro)
                } else if percentage > 0, currentPrice >= price * (1 + percentage) {
                    self.schedulePercentageChangeNotification(targetChange: percentage, crypto: crypto, euro: euro)
                }
            }
        }

        task.setTaskCompleted(success: true)
    }
}

