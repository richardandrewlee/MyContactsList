//
//  Validator.swift
//  MyContacts
//
//  Created by Richard Lee on 8/9/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    
    func empty() -> Bool {
        return (self.text!.trimmingCharacters(in: .whitespaces) == "")
    }
    
    func addDoneButtonOnKeyboard(button:UIBarButtonItem)
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = button
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.string(from: self)
    }
}

extension NSDate {
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self as Date)
    }
    
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }

    public func setTime(hour: Int, min: Int, sec: Int, timeZoneAbbrev: String = "UTC") -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self as Date)
        
        components.timeZone = TimeZone(abbreviation: timeZoneAbbrev)
        components.hour = hour
        components.minute = min
        components.second = sec
        
        return cal.date(from: components)
    }
    
    public func currentYear() -> Int{
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let result = formatter.string(from: date)
        
        return Int(result)!
    }
    
    public func setNextBirthday() -> NSDate? {
       
        let year = currentYear()
        
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self as Date)
        components.year = year
        var date = cal.date(from: components)
        
        if date! < Date()  {
            components.year = year + 1
            date = cal.date(from: components)
        }
        
        return date as NSDate?
    }
}

