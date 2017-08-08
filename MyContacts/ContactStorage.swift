//
//  ContactStorage.swift
//  MyContacts
//
//  Created by Courtney Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import RealmSwift

class StoreLocation {
    //static var store = StoreLocation()
    
    // Notifications on item model
    var notificationToken : NotificationToken? = nil
    let realm = try! Realm()
    var locations: Results<Contact> {
        get {
            return realm.objects(Contact.self).sorted(byKeyPath: "lastName", ascending: true)
        }
    }
    var selectedItem : Contact!
    enum sortBy {
        case date, title
    }
    
    var sortMethod = sortBy.date
    var dateFormatter = DateFormatter()
    
    init(){
        print("Storage Init")
        observe()
        
    }
    
    deinit {
        notificationToken?.stop()
    }
    
    func observe(){
        print("observing")
        // Observe Results Notifications
        notificationToken = locations.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            // guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial, .update(_, deletions: _, insertions: _, modifications: _):
                // Results are now populated and can be accessed without blocking the UI
                //print("contents of realm \(self?.locations)")
                break
                
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    func deleteAll(){
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func delete(_ contact : Contact){
        try! realm.write {
            realm.delete(contact)
        }
    }
    
    func save(_ contact : Contact) {
        try! realm.write({
            realm.add(contact)
        })
    }
    
}
