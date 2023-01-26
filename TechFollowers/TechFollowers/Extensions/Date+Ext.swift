//
//  Date+Ext.swift
//
//  Created by Rashad Surratt on 1/17/23.
//

import Foundation

extension Date {
    
    // Old way:
    
//    func convertToMonthYearFormat() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM YYY"
//        return dateFormatter.string(from: self)
//    }
//
    func convertToMonthYearFormat() -> String {
        return formatted()
    }
}
