//
//  EventCreation.swift
//  MyContacts
//
//  Created by Richard Lee on 8/9/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import UIKit
import EventKit


class EventCreation {
    
    static func make(name:String, date:NSDate, whenDone: @escaping () -> Void){
        
        let eventStore : EKEventStore = EKEventStore()
        
        // 'EKEntityTypeReminder' or 'EKEntityTypeEvent'
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            
            if (granted) && (error == nil) {
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = "\(name)'s Birthday!"
                event.startDate = (date.setNextBirthday()?.startOfDay)!
                event.endDate = (date.setNextBirthday()?.endOfDay!)!
                event.notes = "Don't for get it!"
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    whenDone()
                } catch let e as NSError {
                    //completion(false, e)
                    print("error \(e)")
                    return
                }
                
            } 
        })
            
    }
}
