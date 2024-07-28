//
//  Date+Ext.swift
//  GHFollowers
//
//  Created by MasterBi on 25/7/24.
//

import UIKit

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
