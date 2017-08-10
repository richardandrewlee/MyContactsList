//
//  ContactStorage.swift
//  MyContacts
//
//  Created by Richard Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import RealmSwift

class ContactStorage {
    
    static var store = ContactStorage()
    
    // Notifications on item model
    var notificationToken : NotificationToken? = nil
    let realm = try! Realm()
    var contacts : Results<Contact> {
        get {
            return realm.objects(Contact.self).sorted(byKeyPath: "sortString", ascending: true)
        }
    }
    var searched : Results<Contact>!
    
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
        notificationToken = contacts.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            // guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial, .update(_, deletions: _, insertions: _, modifications: _):
                // Results are now populated and can be accessed without blocking the UI
                //print("contents of realm \(self?.contacts)")
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
