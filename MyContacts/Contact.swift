//
//  Contact.swift
//  MyContacts
//
//  Created by Courtney Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import RealmSwift

class Contact : Object {
    
    // Textual information about the location
    dynamic var firstName   : String   = ""
    dynamic var lastName    : String   = ""
    dynamic var dateOfBirth : String   = ""
    dynamic var phoneNumber : String   = ""
    dynamic var zipCode     : String   = ""
}

