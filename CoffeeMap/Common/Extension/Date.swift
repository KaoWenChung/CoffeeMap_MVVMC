//
//  Date.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/11.
//

import Foundation

extension Date {
    func toString(dateFormat: String = "yyyy/MM/dd HH:mm:ss", locale: Locale? = nil, timeZone: TimeZone? = nil) -> String {
        let format: DateFormatter = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = locale
        format.timeZone = timeZone
        let dateStr: String = "\(format.string(from: self))"
        return dateStr
    }
}
