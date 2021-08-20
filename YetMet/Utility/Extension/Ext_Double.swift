//
//  Ext_Double.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import Foundation

extension Double {
    var toString: String {
       return NSNumber(value: self).stringValue
    }
    
    func round(_ places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func getDateFromUnix() -> Date {
        let date = Date(timeIntervalSince1970: self)
        return date
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        return formatter
    }()
}

extension Numeric {
    var format: String { Formatter.withSeparator.string(for: self) ?? "" }
}
