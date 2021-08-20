//
//  Ext_Date.swift
//  YetMet
//
//  Created by Sun on 2021/8/2.
//

import Foundation
import UIKit

extension Date {
    var age: Int {
        Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    //history time
    func historyTime() -> String {
        let currentTime = Date()
        let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .month, .year])
        let diff_time = Calendar.current.dateComponents(components, from: self, to: currentTime)
        
        var str = ""
        if diff_time.year! == 0 {
            if diff_time.month! == 0 {
                if diff_time.day! == 0 {
                    if diff_time.hour! == 0 {
                        if diff_time.minute! == 0  {
                            if diff_time.second == 0 {
                                str = "just ago"
                            } else {
                                str = "1 minute ago"
                            }
                        } else {
                            str = (diff_time.minute! == 1) ? "\(diff_time.minute!) minute ago" : "\(diff_time.minute!) minutes ago"
                        }
                    } else {
                        str = (diff_time.hour! == 1) ? "\(diff_time.hour!) hour ago" : "\(diff_time.hour!) hours ago"
                    }
                } else {
                    str = (diff_time.day! == 1) ? "\(diff_time.day!) day ago" : "\(diff_time.day!) days ago"
                }
            } else {
                str = (diff_time.month! == 1) ? "\(diff_time.month!) month ago" : "\(diff_time.month!) months ago"
            }
        } else {
            str = (diff_time.year! == 1) ? "\(diff_time.year!) year ago" : "\(diff_time.year!) years ago"
        }
        
        return str
    }
    //get nearest 30 min
    func nearest30min() -> Date {
        var components = NSCalendar.current.dateComponents([.minute], from: self)
        let minute = components.minute ?? 0
        components.minute = minute >= 30 ? 30 - minute : -minute
        return Calendar.current.date(byAdding: components, to: self)!
    }
    
    //date only without hour, minutes, seconds
    func getDateOnly() -> Date {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        formatter.timeZone = TimeZone.current
        let date_string = formatter.string(from: self)
        let date = formatter.date(from: date_string)
        return date!
    }
    
    //time
    func time() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let time = formatter.string(from: self)
        return time
    }
    
    //time 12 hours
    func time_12() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        let time = formatter.string(from: self)
        return time
    }
    
    func catch_date() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd:HH-mm"
        let date = formatter.string(from: self)
        return date
    }
    
    func pro_date() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, EEEE"
        let date = formatter.string(from: self)
        return date
    }
    
    //day, short month, year
    func day_month_year() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        return dateFormatter.string(from: self)
    }
    
    //year, month, day
    func year_month_day() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    //month, day, year
    func month_day_year() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        return dateFormatter.string(from: self)
    }
    
    //month, day, week,year
    func month_day_week_year() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd, EEE, yyyy"
        return dateFormatter.string(from: self)
    }
    
    //short day and month
    func monthAndDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let month = formatter.string(from: self)
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "dd"
        let day = formatterDay.string(from: self)
        return day + " " + month
    }
    
    //day and full month
    func full_month_day() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: self)
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "d"
        let day = formatterDay.string(from: self)
        return day + " " + month
    }
    
    //full month name and year
    func monthAndyear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let full_string = dateFormatter.string(from: self)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: self)
        let year = full_string.substring(from: full_string.count-4)
        return month + " " + year
    }
    
    //day,full month, year
    func fullFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: self)
        let formatterDay = DateFormatter()
        formatterDay.dateFormat = "d"
        let day = formatterDay.string(from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let full_string = dateFormatter.string(from: self)
        let year = full_string.substring(from: full_string.count-4)
        return day + " " + month + " " + year
    }
    
    //day,short month, year
    func fullFormat_shortmonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let full_string = dateFormatter.string(from: self)
        let monthAndDay = self.monthAndDay()
        let year = full_string.substring(from: full_string.count-4)
        return monthAndDay + " " + year
    }
    
    //weekday , day, month
    func week_day_month() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE dd/MM"
        let day = formatter.string(from: self)
        return day
    }
    
    //get weekday
    func weekDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let weekday = formatter.string(from: self)
        return weekday
    }
    
    //full weekday and short day
    func fullWeekday_month_day() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        let weekday = formatter.string(from: self)
        let monthAndDay = self.monthAndDay()
        return weekday + ", " + monthAndDay
    }
}
