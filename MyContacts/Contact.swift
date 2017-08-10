//
//  Contact.swift
//  MyContacts
//
//  Created by Richard Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Contact : Object {
    dynamic var firstName   : String = ""
    dynamic var lastName    : String = ""
    dynamic var fullName    : String = ""
    dynamic var sortString  : String = ""
    dynamic var dateOfBirth : String = ""
    dynamic var dob         : NSDate = NSDate()
    dynamic var phoneNumber : String = ""
    dynamic var zipCode     : String = ""
}

