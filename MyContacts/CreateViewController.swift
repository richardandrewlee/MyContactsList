//
//  CreateViewController.swift
//  MyContacts
//
//  Created by Courtney Lee on 8/8/17.
//  Copyright © 2017 Richard Lee. All rights reserved.
//

import Foundation
import UIKit

class CreateViewController: BaseViewController {
    
    weak var delegate : ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToPreviousViewController(_ sender: Any) {
        self.popToPreviousViewController()
    }
    
    @IBAction func hideCreator(_ sender: Any) {
        delegate?.pushToContact()
        dismiss(animated: true, completion: nil)
    }
}
