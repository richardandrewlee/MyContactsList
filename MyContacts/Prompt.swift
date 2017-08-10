//
//  Prompt.swift
//  MyContacts
//
//  Created by Richard Lee on 8/9/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import UIKit

class Prompt {
    
    static func basicAlert(title: String, message: String, buttonTitle: String, parent: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertActionStyle.default, handler: nil))
        parent.present(alert, animated: true, completion: nil)
    }
    
}
