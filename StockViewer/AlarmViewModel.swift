//
//  AlarmaViewModel.swift
//  StockViewer
//
//  Created by Inna Castro on 16/12/24.
//


//
//  AlarmaViewModel.swift
//  Alarma
//
//  Created by alumno on 29/11/24.
//

import Foundation

class AlarmViewModel: ObservableObject {
    
    func setPriceAlarm(targetPrice: Double, crypto: CryptoCurrency) {
        NotificationManager.shared.schedulePriceNotification(
            targetPrice: targetPrice, crypto: crypto
        )
    }
    
    func setPercentageChangeAlarm(percentageChange: Double, crypto: CryptoCurrency) {
        NotificationManager.shared.schedulePercentageChangeNotification(
            targetChange: percentageChange, crypto: crypto
        )
    }

}
