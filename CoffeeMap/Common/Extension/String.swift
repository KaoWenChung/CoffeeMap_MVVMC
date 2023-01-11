//
//  String.swift
//  CoffeeMap
//
//  Created by wyn on 2023/1/11.
//

import Foundation

extension String {
    func toDate(dateFormat: String = "yyyy/MM/dd HH:mm:ss", locale: Locale? = nil, timeZone: TimeZone? = nil) -> Date? {
        let format: DateFormatter = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = locale
        format.timeZone = timeZone
        let date: Date? = format.date(from: self)
        return date
    }
}
